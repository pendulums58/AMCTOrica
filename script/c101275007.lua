--수렵표적 고어-마가라
local s,id=GetID()
function s.initial_effect(c)
	YiPi.HuntTarget(c)
	--효과 제한
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.accon1)
	e1:SetValue(s.aclimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.accon2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter2)
end
function s.chainfilter1(re,tp,cid)
	if Duel.GetFlagEffect(tp,id)==0 then return true end
	return not (c:IsType(TYPE_MONSTER) and c:GetSummonLocation()==LOCATION_EXTRA)
end
function s.chainfilter2(re,tp,cid)
	if Duel.GetFlagEffect(1-tp,id)==0 then return true end
	return not (c:IsType(TYPE_MONSTER) and c:GetSummonLocation()==LOCATION_EXTRA)
end
function s.accon1(e)
	local p=e:GetHandlerPlayer()
	return Duel.GetCustomActivityCount(id,p,ACTIVITY_CHAIN)>0
end
function s.accon2(e)
	local p=e:GetHandlerPlayer()
	return Duel.GetCustomActivityCount(id,1-p,ACTIVITY_CHAIN)>0
end
function s.aclimit(e,re,tp)
	return c:IsType(TYPE_MONSTER) and c:GetSummonLocation()==LOCATION_EXTRA
end