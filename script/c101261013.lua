--BST MarL
function c101261013.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101261013.ulcon)
	e1:SetUnlock(101261014)
	c:RegisterEffect(e1)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c101261013.unlockeff)
end
function c101261013.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101261013.chk,2,nil)
end
function c101261013.chk(c)
	return c:GetPreviousCodeOnField()==BLANK_NAME and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c101261013.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c101261013.nop)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
end
function c101261013.nop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,101261014)==0 then
		Duel.RegisterFlagEffect(0,101261014,RESET_PHASE+PHASE_END,0,1)
		local g=eg:Filter(Card.IsNotCode,nil,BLANK_NAME)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(101261000)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
