--수렵표적 다라-아마듈라
local s,id=GetID()
function s.initial_effect(c)
	YiPi.HuntTarget(c)
	--필드 수 제한
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_MAX_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(3)
	c:RegisterEffect(e1)
end