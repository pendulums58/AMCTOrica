--드림 오브 크리스탈
function c101223183.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101223183.ulcon)
	e1:SetUnlock(101223184)
	c:RegisterEffect(e1)	
end
function c101223183.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and eg:IsExists(c101223183.spfilter,1,nil)
end
function c101223183.spfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end