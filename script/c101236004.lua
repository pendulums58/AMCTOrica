--발할라(Va-11 Hall-A)의 그림자 리바
function c101236004.initial_effect(c)
	--페어링
	c:EnableReviveLimit()
	--특소 조건
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101236004.splimit)
	c:RegisterEffect(e1)
	--1번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101236004)
	e2:SetCondition(c101236004.negcon)
	e2:SetCost(c101236004.negcost)
	e2:SetTarget(c101236004.negtg)
	e2:SetOperation(c101236004.negop)
	c:RegisterEffect(e2)
	--2번 효과
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c101236004.limcon)
	e3:SetValue(aux.TRUE)
	c:RegisterEffect(e3)
end
function c101236004.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(101236020) or se:GetHandler():IsCode(101236008) or se:GetHandler():IsCode(101236011)
end
function c101236004.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not rp~=tp and Duel.IsChainNegatable(ev)
end
function c101236004.cfilter(c)
	return c:IsSetCard(0x660)
end
function c101236004.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101236003.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c101236004.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c101236004.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101236004.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
end
function c101236004.limcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end