--아에기르의 술잔
function c101236009.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--혼합
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c101236009.operation)
	c:RegisterEffect(e2)
end
function c101236009.operation(e,tp,eg,ep,ev,re,r,rp)
	yipi.Blend(e:GetHandler(),tp)
end