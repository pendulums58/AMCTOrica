--스러진 기억의 잔류물
local s,id=GetID()
function s.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	--개방
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ulcon)
	e1:SetUnlock(id+1)
	c:RegisterEffect(e1)	
end
function s.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.filter(c,tp)
	return c:IsOwner(tp) and c:GetPreviousControler()==1-tp
end