--모든 속박이 풀리는 날
function c111335011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetCost(c111335011.cost)
	e1:SetOperation(c111335011.activate)
	c:RegisterEffect(e1)	
end
c111335011.remove_counter=0x326  
function c111335011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x326,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x326,3,REASON_COST)
end
function c111335011.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c111335011.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c111335011.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() and not te:GetOwner():IsSetCard(0x652)
end