--백은의 결연희
local s,id=GetID()
function s.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)	
	--개방
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
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
	return c:IsControler(tp) and Duel.IsExistingMatchingCard(s.ulchk2,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,c)
end
function s.ulchk2(c,tc)
	return c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(tc)
end