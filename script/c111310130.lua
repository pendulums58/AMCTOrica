--이매진 페인터
function c111310130.initial_effect(c)
	--개방
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c111310130.ulcon)
	e1:SetUnlock(111310131)
	c:RegisterEffect(e1)
	if not c111310130.global_check then
		c111310130.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c111310130.checkop)
		Duel.RegisterEffect(ge1,0)
	end	
end
function c111310130.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_ACCESS) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),111310130,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c111310130.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetFlagEffect(tp,111310130)==2 and eg:IsExists(Card.IsSummonType,1,nil,TYPE_ACCESS)
end