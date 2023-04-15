--BST MarL
function c101261014.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c101261014.unlockeff)	
	--추가 일소권
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10719350,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101261014.escon)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x62b))
	c:RegisterEffect(e1)
	--공백 만들기
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101261014.distg)
	e2:SetOperation(c101261014.disop)	
	c:RegisterEffect(e2)	
end
function c101261014.escon(e)
	return e:GetHandler():IsCode(BLANK_NAME)
end
function c101261014.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c101261014.nop)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
end
function c101261014.nop(e,tp,eg,ep,ev,re,r,rp)
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
function c101261014.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsNotCode(BLANK_NAME) and re:GetHandler():IsOnField() end
end
function c101261014.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsRelateToEffect(re) and tc:IsFaceup() and tc:IsOnField() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(101261000)
		tc:RegisterEffect(e1)		
	end
end