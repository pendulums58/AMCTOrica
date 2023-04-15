--추적의 직시자 트라칼
function c101220014.initial_effect(c)
	--엑시즈 조건
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--광역 무효화
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetDescription(aux.Stringid(101220014,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101220014.cost)
	e1:SetTarget(c101220014.distg)
	e1:SetOperation(c101220014.disop)
	c:RegisterEffect(e1)
	--공뻥
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101220014,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(c101220014.con)
	e2:SetOperation(c101220014.op)
	c:RegisterEffect(e2)	
end
function c101220014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101220014.cfilter(c)
	return c:IsSetCard(0xefa) and c:IsType(TYPE_MONSTER)
end
function c101220014.desfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c101220014.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101220014.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetChainLimit(aux.FALSE)
end
function c101220014.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cd=Duel.GetMatchingGroupCount(c101220014.cfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.SelectMatchingCard(tp,c101220014.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,cd,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		tc=g:GetNext()
	end
end
function c101220014.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsDisabled()
end
function c101220014.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(1500)
		c:RegisterEffect(e1)

	end
end
