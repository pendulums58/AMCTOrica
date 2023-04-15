--붉고 푸른 장미의 관리자
c101241006.AccessMonsterAttribute=true
function c101241006.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241006.afil1,c101241006.afil2)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101241006.con)
	e1:SetOperation(c101241006.op)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(c101241006.rcon)
	c:RegisterEffect(e2)
	--내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101241006,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c101241006.target)
	e3:SetOperation(c101241006.operation)
	c:RegisterEffect(e3)
	--창조
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101241006,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c101241006.rcon)
	e4:SetTarget(c101241006.thtg)
	e4:SetOperation(c101241006.thop)
	c:RegisterEffect(e4)
	--어드민 제거
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101241006,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c101241006.rrcon)
	e5:SetCost(c101241006.rmcost)
	e5:SetOperation(c101241006.rmop)
	c:RegisterEffect(e5)
end
function c101241006.afil1(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and bit.band(c:GetSummonLocation(),LOCATION_GRAVE)~=0
end
function c101241006.afil2(c)
	return c:IsType(TYPE_ACCESS)
end
function c101241006.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101241006.op(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 물들어가는 장미의 관리자가 개화했습니다.")
end
function c101241006.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c101241006.rrcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()~=nil
end
function c101241006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c101241006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c101241006.valcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101241006.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c101241006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_GRAVE,0,1,nil) end
end
function c101241006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):RandomSelect(tp,1):GetFirst()
	if tc then
		local token=Duel.CreateToken(tp,tc:GetCode())
		Duel.SendtoHand(token,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,token)
		Duel.ShuffleHand(tp)
	end
end
function c101241006.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_GRAVE,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):RandomSelect(tp,5)
	if tc:GetCount()==5 then
		Duel.Delete(e,tc)
	end
end
function c101241006.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end