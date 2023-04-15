--뇌명, 벽력에 몸을 기대는
function c101262008.initial_effect(c)
	--회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101262008)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101262008.thtg)
	e1:SetOperation(c101262008.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--충전 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EFFECT_RAIMEI_IM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c101262008.thcon)
	e2:SetTarget(c101262008.btg)
	e2:SetOperation(c101262008.bop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101262008,ACTIVITY_CHAIN,c101262008.chainfilter)
end
function c101262008.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(56260110)
end
function c101262008.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and c101262008.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101262008.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local tc=Duel.SelectTarget(tp,c101262008.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,tp,LOCATION_GRAVE)
	if tc:GetFirst():IsCode(56260110) then
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	else
		e:SetCategory(CATEGORY_TOHAND)
	end
end
function c101262008.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsCode(56260110)
		and Duel.IsExistingMatchingCard(c101262008.thfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101262008,0)) then
		local g=Duel.SelectMatchingCard(tp,c101262008.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(g,1-tp)
		end
	end
end
function c101262008.thfilter(c)
	return c:IsSetCard(0x62d) and c:IsAbleToHand()
end
function c101262008.thfilter1(c)
	return c:IsCode(56260110) and c:IsAbleToHand()
end
function c101262008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101262008,tp,ACTIVITY_CHAIN)~=0
end
function c101262008.btg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,tp,LOCATION_ONFIELD)
end
function c101262008.bop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end