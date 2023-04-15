--한정해제자 니힐리스
function c101252011.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101252011.ulcon)
	e1:SetUnlock(101252012)
	c:RegisterEffect(e1)
	if not c101252011.global_check then
		c101252011.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c101252011.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101252011.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101252011)>0
end
function c101252011.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg and eg:IsExists(c101252011.chk,1,nil,tp) and rp==1-tp then
		Duel.RegisterFlagEffect(tp,101252011,RESET_PHASE+PHASE_END,0,1)
	end
	if eg and eg:IsExists(c101252011.chk,1,nil,1-tp) and rp==tp then
		Duel.RegisterFlagEffect(1-tp,101252011,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101252011.chk(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp
end