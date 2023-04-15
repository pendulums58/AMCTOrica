--회상 벚꽃
function c103555014.initial_effect(c)
	--공격 무효
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103551014,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,103555014)
	e1:SetCondition(c103555014.condition)
	e1:SetCost(c103555014.cost)
	e1:SetTarget(c103555014.target)
	e1:SetOperation(c103555014.operation)
	c:RegisterEffect(e1)	
	cyan.AddSakuraEffect(c)	
end
function c103555014.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttacker()
	return at:IsControler(1-tp)
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		or Duel.IsPlayerAffectedByEffect(c:GetControler(),103555011))
end
function c103555014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c103555014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c103555014.chlimit(TYPE_MONSTER))
end
function c103555014.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end
function c103555014.chlimit(ctype)
	return function(e,ep,tp)
		return tp==ep or e:GetHandler():GetOriginalType()&ctype==0
	end
end