--천공영사 아테르시아
function c101223178.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c101223178.ulcon)
	e1:SetUnlock(101223179)
	c:RegisterEffect(e1)
end
c101223178.listed_names={CARD_SANCTUARY_SKY}
function c101223178.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223178.filter,1,nil,tp) and (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_SANCTUARY_SKY),tp,LOCATION_ONFIELD,0,1,nil)
	or Duel.IsEnvironment(CARD_SANCTUARY_SKY,tp))
end
function c101223178.filter(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsPreviousControler(tp)
end