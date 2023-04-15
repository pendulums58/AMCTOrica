--마나 페네트레이터
function c101223139.initial_effect(c)
	--히히 마법 막아야지
	local e1=Effect.CreateEffect(c)
	e1:SetRange(LOCATION_HAND)	
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)	
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101223139)	
	e1:SetCost(c101223139.discost)	
	e1:SetCondition(c101223139.setcon)	
	e1:SetOperation(c101223139.op)
	c:RegisterEffect(e1)	
end
function c101223139.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c101223139.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_DECK) and c:IsSummonPlayer(1-tp)
end
function c101223139.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223139.cfilter,1,nil,tp)
end
function c101223139.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101223139.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101223139.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end