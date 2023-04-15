--시계탑의 성흔
function c101213310.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101213310.target)
	e1:SetOperation(c101213310.activate)
	c:RegisterEffect(e1)	
	
end
function c101213310.filter(c)
	return c:IsCode(101213309) and c:IsAbleToHand()
end
function c101213310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213310.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101213310.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101213310.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,75041269) then
				local tw=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD,0,nil,75041269)
				local tc=tw:GetFirst():GetCounter(0x1b)
				if Duel.IsExistingMatchingCard(c101213310.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,tc)
					and Duel.SelectYesNo(tp,aux.Stringid(101213310,0))
					and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
					local g1=Duel.SelectMatchingCard(tp,c101213310.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,tc)
					local tc1=g1:GetFirst()
					if tc1 then
						Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
					end					
				end
		end
	end
end
function c101213310.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x60a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLevelBelow(lv) or (c:IsType(TYPE_XYZ) and c:GetRank()<=lv))
end