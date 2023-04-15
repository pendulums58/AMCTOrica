--파르테리스
function c101269002.initial_effect(c)
	--레벨 상승
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101269002.tg)
	e1:SetOperation(c101269002.op)
	c:RegisterEffect(e1)
end
function c101269002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetLevel()<12 and Duel.IsExistingMatchingCard(c101269002.chk,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end	
end
function c101269002.chk(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x641)
end
function c101269002.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c101269002.chk,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if ct>0 then	
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(ct*2)
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		if c:GetLevel()>4 then
			Duel.Damage(1-tp,600,REASON_EFFECT)
		end
		if c:GetLevel()>6 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,101269900,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,101269900)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end