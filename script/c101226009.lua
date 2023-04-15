--신살마녀의 회향
function c101226009.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101226009)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101226009.target)
	e1:SetOperation(c101226009.activate)
	c:RegisterEffect(e1)	
end
function c101226009.filter(c,def)
	return c:IsSetCard(0x612) and c:IsAttackBelow(def) and c:IsAbleToHand()
end
function c101226009.thfilter(c,tp)
	return Duel.IsExistingMatchingCard(c101226009.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetAttack())
end
function c101226009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and Duel.IsExistingMatchingCard(c101226009.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,chkc:GetAttack()) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101226009.thfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.SelectTarget(tp,c101226009.thfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101226009.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()	
	local val=tc:GetAttack()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c101226009.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,val)
	local sc=g1:GetFirst()
	if sc then
		val=val-sc:GetAttack()
		if Duel.IsExistingMatchingCard(c101226009.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,sc,val)
			and Duel.SelectYesNo(tp,aux.Stringid(101226009,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c101226009.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,sc,val)
			g1:Merge(g2)
		end
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end