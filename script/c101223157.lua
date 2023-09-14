--소피의 지배력
function c101223157.initial_effect(c)
	c:SetUniqueOnField(1,0,101223157)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223157.actcon)
	c:RegisterEffect(e1)
	--무효화 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c101223157.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c101223157.effectfilter)
	c:RegisterEffect(e3)	
	--서치
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c101223157.target)
	e4:SetOperation(c101223157.operation)
	c:RegisterEffect(e4)
	--제외
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c101223157.rmcon)
	e5:SetTarget(c101223157.rmtg)
	e5:SetOperation(c101223157.rmop)	
	c:RegisterEffect(e5)
end
function c101223157.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223157.chk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223157.chk(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c101223157.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsType(TYPE_FUSION)
end
function c101223157.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE)
		and c101223157.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101223157.tgfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,c101223157.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101223157.tgfilter(c,tp)
	return c:GetReason()&(REASON_FUSION+REASON_MATERIAL)==(REASON_FUSION+REASON_MATERIAL) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c101223157.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c101223157.thfilter(c,tc)
	return c:IsAbleToHand() and c:IsSetCardList(tc) and not c:IsCode(tc:GetCode()) and c:IsType(TYPE_MONSTER)
end
function c101223157.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(c101223157.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(g,1-tp)
		end
	end
end
function c101223157.cfilter2(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c101223157.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223157.cfilter2,1,nil,tp)
end
function c101223157.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c101223157.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end