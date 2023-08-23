--수렵표적 고어-마가라
local s,id=GetID()
function s.initial_effect(c)
	YiPi.HuntTarget(c)
	--효과 제한
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.accon)
	e1:SetValue(s.aclimit)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
	local p=re:GetHandlerPlayer()
	local cd=re:GetHandler()
	if Duel.GetFlagEffect(p,id)==0 then return true end
	return not (cd:IsType(TYPE_MONSTER) and cd:GetSummonLocation()==LOCATION_EXTRA)
end
function s.accon(e,re)
	local p=re:GetHandlerPlayer()
	return Duel.GetCustomActivityCount(id,p,ACTIVITY_CHAIN)>0
end
function s.aclimit(e,re,tp)
	local cd=re:GetHandler()
	return cd:IsType(TYPE_MONSTER) and cd:GetSummonLocation()==LOCATION_EXTRA
end