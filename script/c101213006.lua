--결연희 네트워크
function c101213006.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101213006.target)
	e1:SetOperation(c101213006.activate)
	c:RegisterEffect(e1)
end
function c101213006.filter4(c)
	return c:IsSetCard(0xef3) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c101213006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ml=Duel.GetMatchingGroup(c101213006.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=ml:GetCount()
	local go=0
	if Duel.IsExistingMatchingCard(c101213006.filter4,tp,LOCATION_DECK,0,1,nil) then
		go=1
	end
	if ct>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101213006.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		go=1
	end
	if ct>=3 and Duel.IsExistingMatchingCard(c101213006.filter1,tp,LOCATION_DECK,0,1,nil) then
		go=1
	end
	if ct>=4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101213006.filter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		go=1
	end
	if chk==0 then return go==1 end
	if ct>=4 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
	if ct>=2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101213006.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c101213006.filter4,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101213006.filter4,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>=0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	local ml=Duel.GetMatchingGroup(c101213006.cfilter,tp,LOCATION_MZONE,0,nil)
		local ct=ml:GetCount()
		--2장 이상
		if ct>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.IsExistingMatchingCard(c101213006.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101213006.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
		--3장 이상
		if ct>2 then
			if Duel.IsExistingMatchingCard(c101213006.filter1,tp,LOCATION_DECK,0,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,c101213006.filter1,tp,LOCATION_DECK,0,1,1,nil)
					if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
					end
			end
		end
		--4장 이상
		if ct>3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.IsExistingMatchingCard(c101213006.filter,tp,LOCATION_DECK,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c101213006.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
end
function c101213006.cfilter(c)
	return c:IsSetCard(0xef3) and c:GetMutualLinkedGroupCount()>0
end
function c101213006.filter(c,e,tp)
	return c:IsSetCard(0xef3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101213006.filter1(c)
	return c:IsSetCard(0xef3) and c:IsAbleToHand() and not c:IsCode(101213006)
end