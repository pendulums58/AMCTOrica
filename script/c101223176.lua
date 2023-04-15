--살아갈 실마리
function c101223176.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetLocation(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c101223174.ulcon)
	e1:SetUnlock(101223175)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_PAY_LPCOST)
	c:RegisterEffect(e2)
end
function c101223174.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=4000
end