--백청의 관리자
function c111310128.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310128.afil1,c111310128.afil2)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310128.con)
	e1:SetOperation(c111310128.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(c111310128.rcon)
	c:RegisterEffect(e2)
	--무효
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111310128,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c111310128.condition1)
	e3:SetTarget(c111310128.target)
	e3:SetOperation(c111310128.operation)
	c:RegisterEffect(e3)
	--무효 후 제외
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(111310128,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c111310128.negcon)
	e4:SetTarget(c111310128.negtg)
	e4:SetOperation(c111310128.negop)
	c:RegisterEffect(e4)
	--어드민 제거
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c111310128.rmcon)
	e5:SetCost(c111310128.cost)
	e5:SetOperation(c111310128.rmop)
	c:RegisterEffect(e5)	
end
function c111310128.afil1(c)
	return c:GetLevel()==1
end
function c111310128.afil2(c)
	return c:GetAttack()<=2500
end
function c111310128.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310128.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 순수 관리자 권한이 감지되었습니다.")
end
function c111310128.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c111310128.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and rc:GetAttack()>=2700
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c111310128.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c111310128.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	end
end
function c111310128.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and c:GetAdmin()==nil
		and rp~=tp
end
function c111310128.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c111310128.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c111310128.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad
end
function c111310128.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310128.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c111310128.cfilter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c111310128.cfilter2(c)
	return c:IsType(TYPE_ACCESS) and c:IsAbleToRemoveAsCost()
end
function c111310128.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end