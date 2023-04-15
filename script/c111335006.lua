--바르그 사냥꾼 비다르
function c111335006.initial_effect(c)
--엑시즈
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x652),4,2)
	c:EnableReviveLimit()		
--카운터 증가
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111335006,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)	
	e1:SetCountLimit(1)
	e1:SetTarget(c111335006.cttg)
	e1:SetOperation(c111335006.ctop)
	c:RegisterEffect(e1)
--공뻥!!!!
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111335006,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)		
	e2:SetCost(c111335006.cost)
	e2:SetOperation(c111335006.operation)
	c:RegisterEffect(e2)
end
--카운터 증가
function c111335006.filter(c,e,tp)
	return c:IsFaceup() and c:IsCode(111335009)
end
function c111335006.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111335006.filter,tp,LOCATION_SZONE,0,1,nil,0x326,1) end
end
function c111335006.ctop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c111335006.filter,tp,LOCATION_SZONE,0,nil,0x326,1)
	local tc=g:GetFirst()
	while tc do
	tc:AddCounter(0x326,1)
	tc=g:GetNext()
	end
end
--공뻥!!!!
function c111335006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c111335006.up(e,c)
	return Duel.GetCounter(0,1,1,0x326)*700
end
function c111335006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c111335006.up)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end