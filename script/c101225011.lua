--흑백의 양염
function c101225011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101225011)		
	e1:SetCost(c101225011.cost)
	e1:SetTarget(c101225011.target)
	e1:SetOperation(c101225011.activate)
	c:RegisterEffect(e1)	
end
function c101225011.cfilter(c)
	return c:IsSetCard(0x60b) and c:IsDiscardable()
end
function c101225011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101225011.cfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,c101225011.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c101225011.filter(c)
	return c:IsSetCard(0x60b) and c:IsAbleToHand() and not c:IsCode(101225011)
end
function c101225011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101225011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101225011.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101225011.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end