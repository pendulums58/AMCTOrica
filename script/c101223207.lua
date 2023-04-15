--창성유물『소암성순』
local s,id=GetID()
function s.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.ulcon)
	e1:SetUnlock(id+1)
	c:RegisterEffect(e1)	
end
function s.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.ulchk,1,nil)
end
function s.ulchk(c)
	return c:IsLevel(11) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end