--인랑의 일격
function c101223088.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c101223088.cost)
	e1:SetTarget(c101223088.target)
	e1:SetOperation(c101223088.activate)
	c:RegisterEffect(e1)	
end
function c101223088.cfilter(c,tp)
	return c:IsLevel(4) and c:IsRace(RACE_BEASTWARRIOR) and c:IsAttack(1500) and c:IsDefense(1000) and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c101223088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101223088.cfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c101223088.cfilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c101223088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101223088.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
