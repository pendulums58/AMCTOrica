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
	local e2=e1:clone()
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.accon2)
	c:RegisterEffect(e2)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	local cd=re:GetHandler()
	if cd:IsType(TYPE_MONSTER) and cd:GetSummonLocation()==LOCATION_EXTRA then
		Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.accon1(e,tp)
	return Duel.GetFlagEffect(tp,id)>=1
end
function s.accon2(e,tp)
	return Duel.GetFlagEffect(1-tp,id)>=1
end
function s.aclimit(e,re,tp)
	local cd=re:GetHandler()
	return cd:IsType(TYPE_MONSTER) and cd:GetSummonLocation()==LOCATION_EXTRA
end