--요모츠시코메의 노래
function c112000006.initial_effect(c)
--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,112000006)	
	e1:SetCondition(c112000006.condition)	
	e1:SetTarget(c112000006.target)
	e1:SetOperation(c112000006.activate)
	c:RegisterEffect(e1)
--샐비지	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112000006,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,112000906)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c112000006.thcon)
	e2:SetTarget(c112000006.thtg)
	e2:SetOperation(c112000006.thop)
	c:RegisterEffect(e2)		
end

--서치
function c112000006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 
end
function c112000006.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x663) and c:IsType(TYPE_MONSTER)
end
function c112000006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112000006.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112000006.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c112000006.thfilter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--샐비지
function c112000006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 and aux.exccon(e) 
end
function c112000006.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x663) and c:IsType(TYPE_MONSTER)
end
function c112000006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112000006.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c112000006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c112000006.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
