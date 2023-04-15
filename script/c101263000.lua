--대충테스트
function c101263000.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--환계돌파 대체
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DRACO_ADD)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(3)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
end
