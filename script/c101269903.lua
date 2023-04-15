--CR(크로니클 레플리카)-인내와 구속의 시련
function c101269903.initial_effect(c)
	--카드 덤핑
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101269903)
	e1:SetCost(cyan.selfdiscost)
	e1:SetTarget(c101269903.thtg)
	e1:SetOperation(c101269903.thop)
	c:RegisterEffect(e1)
	--어드민으로 한다
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101269903.adtg)
	e2:SetOperation(c101269903.adop)
	c:RegisterEffect(e2)
end
function c101269903.tgfilter(c,tp)
	return c:IsSetCard(0x641) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c101269903.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c101269903.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101269903.tgfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,c101269903.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c101269903.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c101269903.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
		local tg=sg:Filter(Card.IsCode,nil,tc:GetCode())
		if tg:GetCount()>0 then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c101269903.thfilter(c)
	return c:IsSetCard(0x641) and c:IsAbleToGrave()
end
function c101269903.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_ACCESS) and chkc:IsControler(tp) and chkc:GetAdmin()==nil end
	if chk==0 then return Duel.IsExistingTarget(c101269903.tgfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101269903.tgfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101269903.tgfilter2(c)
	return c:IsType(TYPE_ACCESS) and c:GetAdmin()==nil and c:IsFaceup()
end
function c101269903.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:GetAdmin()==nil then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end