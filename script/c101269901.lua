--CR(크로니클 레플리카)-모험과 유혹의 시련
function c101269901.initial_effect(c)
	--묘지 회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101269901)
	e1:SetCost(cyan.selfdiscost)
	e1:SetTarget(c101269901.thtg)
	e1:SetOperation(c101269901.thop)
	c:RegisterEffect(e1)
	--샐비지 효과 작동
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c101269901.regop)
	c:RegisterEffect(e2)
end
function c101269901.tgfilter(c,tp)
	return c:IsSetCard(0x641) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c101269901.thfilter,tp,LOCATION_GRAVE,0,1,c)
end
function c101269901.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c101269901.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101269901.tgfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,c101269901.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)	
end
function c101269901.thfilter(c)
	return c:IsSetCard(0x641) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c101269901.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c101269901.thfilter,tp,LOCATION_GRAVE,0,1,1,tc)
	if g:GetCount()>0 and Duel.SendtoHand(g,c,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		g:AddCard(tc)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c101269901.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,101269901+100)
	e1:SetRange(LOCATION_GRAVE)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsSetCard,0x641,Card.IsAttribute,ATTRIBUTE_LIGHT,Card.IsType,TYPE_MONSTER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end