--메모리큐어 - 잊혀가는 추억
function c101249016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101249016+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101249016.condition)
	e1:SetCost(c101249016.cost)
	e1:SetTarget(c101249016.target)
	e1:SetOperation(c101249016.activate)
	c:RegisterEffect(e1)
end
function c101249016.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c101249016.cfilter(c,tp)
	return (c:IsSetCard(0x623) or c:IsCode(96765646)) and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c101249016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101249016.cfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c101249016.cfilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c101249016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101249016.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
