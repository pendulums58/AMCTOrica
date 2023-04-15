--몰?루 프레이어
function c101223182.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c101223182.unlockeff)	
	--회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	cyan.JustSearch(e1,LOCATION_GRAVE,Card.IsType,TYPE_MONSTER)
	c:RegisterEffect(e1)
	--대상 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,0)
	e2:SetTarget(c101223182.target)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c101223182.target(e,c)
	return not c==e:GetHandler()
end
function c101223182.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PREVENT_NEGATION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCountLimit(1)
	Duel.RegisterEffect(e1,tp)
end