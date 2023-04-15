--몰?루 프레이어
function c101223181.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101223181.ulcon)
	e1:SetUnlock(101223182)
	c:RegisterEffect(e1)	
end
function c101223181.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return ev>1 and ep==1-tp
end
