--바다 밑에서 건진 달
function c101223172.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(c101223172.ulcon)
	e1:SetUnlock(101223173)
	c:RegisterEffect(e1)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c101223172.unlockeff)
end
function c101223172.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DRAW and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==1
end
function c101223172.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	Duel.RegisterEffect(e1,tp)
end
