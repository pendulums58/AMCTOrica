--퀴라시에 드 몽타뉴
local s,id=GetID()
function s.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	--해금
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.ulcon)
	e1:SetUnlock(id+1)
	c:RegisterEffect(e1)	
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHANGE_POS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,id)>3
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
end