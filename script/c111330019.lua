--천멸의 잔불여우
local s,id=GetID()
function s.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)	
	--해금
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.ulcon)
	e1:SetUnlock(id+1)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>2 and eg:IsExists(s.chk1,1,nil,tp)
end
function s.chk1(c,tp)
	return c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg and eg:IsExists(s.chk,1,nil) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.chk(c)
	return c:IsType(TYPE_MONSTER)
end