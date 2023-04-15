--조 여환무장【컨티뉴어터】
function c101234020.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101234020.pfilter1,c101234020.pfilter2,1,1)
	c:EnableReviveLimit()
	--공뻥
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c101234020.condition)
	e1:SetOperation(c101234020.operation)
	c:RegisterEffect(e1)
end
function c101234020.pfilter1(c)
	return c:IsSetCard(0x611) 
end
function c101234020.pfilter2(c)
	return c:IsSetCard(0x611) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c101234020.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPair():IsRelateToBattle()
end
function c101234020.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	end
end