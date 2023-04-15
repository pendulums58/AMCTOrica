--잔불여우의 여행
function c111330010.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111330010)
	e1:SetTarget(c111330010.target)
	e1:SetOperation(c111330010.activate)
	c:RegisterEffect(e1)	
end
function c111330010.filter(c)
	return c:IsSetCard(0x638) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c111330010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111330010.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111330010.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x638)
end
function c111330010.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111330010.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if Duel.IsExistingMatchingCard(c111330010.thfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(111330010,0)) then
			local g1=Duel.SelectMatchingCard(tp,c111330010.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
			if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT) and
				tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(111330010,1)) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				
			end
		end
	end
end
