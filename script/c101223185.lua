--레트로타임 크로니클
function c101223185.initial_effect(c)
	--특소시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c101223185.spop)
	c:RegisterEffect(e1)
end
function c101223185.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetCount()==1 and eg:GetFirst():GetSummonLocation()==LOCATION_EXTRA and ep==1-tp then
		if Duel.IsPlayerCanSpecialSummonMonster(tp,101223202,0xf,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then
			local tc=eg:GetFirst()
			local token=Duel.CreateToken(101223202,tp)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(tc:GetAttack())
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(tc:GetDefense())
			token:RegisterEffect(e2)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCode(EFFECT_IMMUNE_EFFECT)
			e5:SetValue(c101223185.efilter)
			e5:SetLabelObject(tc)
			token:RegisterEffect(e5)
			Duel.SpecialSummonComplete()
		end
	end
end
function c101223185.efilter(e,re)
	return re:GetHandler()==e:GetLabelObject()
end