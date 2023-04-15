--무라쿠모의 지배력
function c101223162.initial_effect(c)
	c:SetUniqueOnField(1,0,101223162)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223162.actcon)
	c:RegisterEffect(e1)	
	--대상 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetTarget(aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER))
	e2:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)	
	--드로우
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c101223162.drcost)
	e3:SetCountLimit(1)
	cyan.JustDraw(e3,2)
	c:RegisterEffect(e3)
	--점술
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c101223162.rmcon)
	e5:SetTarget(c101223162.rmtg)
	e5:SetOperation(c101223162.rmop)	
	c:RegisterEffect(e5)
end
function c101223162.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223162.chk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223162.chk(c)
	return c:IsFaceup() and c:IsType(TYPE_PAIRING)
end
function c101223162.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101223162.pchk,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c101223162.pchk,1,1,nil)
	Duel.Release(g,REASON_COST)	
end
function c101223162.pchk(c)
	return c:GetPairCount()>0
end
function c101223162.cfilter2(c,tp)
	return c:IsType(TYPE_PAIRING) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c101223162.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223162.cfilter2,1,nil,tp)
end
function c101223162.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanScry(tp,1) end
end
function c101223162.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Scry(e,tp,1)
end