--찰나의 관리자
function c111310137.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310137.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310137.con)
	e1:SetOperation(c111310137.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(cyan.nacon)
	c:RegisterEffect(e2)
	--제외
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(111310137,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c111310137.rmtg)
	e3:SetOperation(c111310137.rmop)
	c:RegisterEffect(e3)
	--복사
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(111310137,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cyan.nacon)
	e4:SetCost(c111310137.cpcost)
	e4:SetTarget(c111310137.cptg)
	e4:SetOperation(c111310137.cpop)
	c:RegisterEffect(e4)
	--어드민 제거
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(111310137,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cyan.adcon)
	e5:SetCost(c111310137.adcost)
	e5:SetOperation(c111310137.adop)
	c:RegisterEffect(e5)
end
function c111310137.afil1(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310137.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310137.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 세계를 떠도는 풍류의 신이 도착했습니다.")
end
function c111310137.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c111310137.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c111310137.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local tc=Duel.SelectTarget(tp,c111310137.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tp,LOCATION_GRAVE)
end
function c111310137.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c111310137.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL)
end
function c111310137.cpfilter(c,exc,e,tp,eg,ep,ev,re,r,rp)
	local te=c:CheckActivateEffect(true,true,false)
	if not (c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() and te and te:GetOperation()) then return false end
	local tg=te:GetTarget()
	return (not tg) or tg(e,tp,eg,ep,ev,re,r,rp,0,nil,exc)
end
function c111310137.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c111310137.cpfilter,tp,LOCATION_GRAVE,0,1,nil,c,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c111310137.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil,c,e,tp,eg,ep,ev,re,r,rp)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c111310137.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if chkc then
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc,c)
	end
	if chk==0 then return true end
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c111310137.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
end
function c111310137.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310137.rmfilter,tp,LOCATION_GRAVE,0,5,nil) end
	local g=Duel.SelectMatchingCard(tp,c111310137.rmfilter,tp,LOCATION_GRAVE,0,5,5,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c111310137.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end