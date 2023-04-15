--뇌명, 영원한 밤에 새기는
function c101262010.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101262010.ulcon)
	e1:SetUnlock(101262011)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101262011,ACTIVITY_CHAIN,c101262010.chainfilter)
	if not c101262010.global_check then
		c101262010.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c101262010.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101262010.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnPlayer()==tp
end
function c101262010.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(ep,101262011,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101262010.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(56260110)
end