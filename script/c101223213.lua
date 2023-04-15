--월하개화 - 달을 맞아 꽃이 피다
local s,id=GetID()
function s.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)	
	--개방
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_MOVED)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ulcon)
	e1:SetUnlock(id+1)
	c:RegisterEffect(e1)	
end
function s.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.ulchk,1,nil,tp)
end
function s.ulchk(c,tp)
	return c:IsControler(tp)
end