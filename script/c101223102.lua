--지령의 뜻
function c101223102.initial_effect(c)
	--Children of the city
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101223102)
	e1:SetTarget(c101223102.tg)
	e1:SetOperation(c101223102.op)
	c:RegisterEffect(e1)
end
function c101223102.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101223102.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function c101223102.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c101223102.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
	if tc:GetCount()>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
		if tc1:GetCount()>0 and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 then
			local tc2=Duel.SelectMatchingCard(tp,c101223102.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if tc2:GetCount()>0 then
				Duel.SendtoHand(tc2,nil,REASON_EFFECT)
			end
		end
	end
end