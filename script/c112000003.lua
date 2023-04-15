--엘리바가르 미스트플라워
function c112000003.initial_effect(c)
	--개방
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c112000003.ulcon)
	e1:SetUnlock(112000004)
	c:RegisterEffect(e1)
	if not c112000003.global_check then
		c112000003.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c112000003.checkop)
		Duel.RegisterEffect(ge1,0)
	end		
end
function c112000003.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,112000003)>1
end
function c112000003.check(c)
	return c and c:IsSetCard(0x663)
end
function c112000003.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local loc=re:GetActivateLocation()	
	if tc and c112000003.check(tc) and loc==LOCATION_GRAVE then
		Duel.RegisterFlagEffect(tp,112000003,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,112000003,RESET_PHASE+PHASE_END,0,1)
	end
end