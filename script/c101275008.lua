--수렵표적 발파루크
local s,id=GetID()
function s.initial_effect(c)
	YiPi.HuntTarget(c)
	--일반 마법 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.aclimit)
	c:RegisterEffect(e1)
end
function s.aclimit(e,re,tp)
	return re:GetHandler():GetType()==TYPE_SPELL and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end