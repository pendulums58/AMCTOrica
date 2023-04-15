--에고파인더-코기토 에르고
function c101217005.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101217005.cost1)
	e1:SetCountLimit(1,101217005)
	e1:SetTarget(c101217005.target)
	e1:SetOperation(c101217005.operation)
	c:RegisterEffect(e1)
end
function c101217005.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101217005.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101217005.filter,1,1,REASON_COST)
end
function c101217005.filter(c)
	return c:IsSetCard(0xef7) and c:IsAbleToGraveAsCost()
end
function c101217005.filter3(c)
	return c:IsCode(101217002) and c:IsAbleToHand()
end
function c101217005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101217005.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101217005.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101217005.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end