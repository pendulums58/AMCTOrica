--심해몽중(싱크로스트)의 결연희
function c101213018.initial_effect(c)
	--덱 3장 갈기
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c101213018.cost)
	e1:SetTarget(c101213018.distarget)
	e1:SetOperation(c101213018.disop)
	c:RegisterEffect(e1)
end
function c101213018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101213018.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c101213018.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,val,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local op1,op2=0
	local aq=g:Filter(c101213018.rmfilter,nil):GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if (aq and Duel.IsExistingMatchingCard(c101213018.spfilter,tp,LOCATION_GRAVE,0,1,aq,e,tp))
		or (Duel.IsExistingMatchingCard(c101213018.spfilter,tp,LOCATION_GRAVE,0,1,aq,e,tp) and g:IsExists(c101213018.rmfilter,1,aq)) then
		op1=1
	end
	if g:IsExists(Card.IsRace,1,nil,RACE_PSYCHO)
		and Duel.IsExistingMatchingCard(c101213018.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
        op2=1
	end
	if op1~=1 and op2~=1 then return end
	local sel=0
	if op1==1 and op2==1 then
		sel=Duel.SelectOption(tp,aux.Stringid(101213018,0),aux.Stringid(101213018,1),aux.Stringid(101213018,2))
		if sel==0 then
			local tc=g:FilterSelect(tp,c101213018.rmfilter,1,1,nil)
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			local tc1=Duel.SelectMatchingCard(tp,c101213018.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
		end
		if sel==1 then
			local tc2=Duel.SelectMatchingCard(tp,c101213018.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
		end
		if sel==2 then return end
	end
	if op1==1 and op2~=1 and Duel.SelectYesNo(tp,aux.Stringid(101213018,0)) then
		local tc=g:FilterSelect(tp,c101213018.rmfilter,1,1,nil)
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		local tc1=Duel.SelectMatchingCard(tp,c101213018.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
	end
	if op1~=1 and op2==1 and Duel.SelectYesNo(tp,aux.Stringid(101213018,1)) then
		local tc2=Duel.SelectMatchingCard(tp,c101213018.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101213018.spfilter(c,e,tp)
	return c:IsSetCard(0xef8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101213018.spfilter1(c,e,tp)
	return c:IsSetCard(0xef3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101213018.rmfilter(c)
	return c:IsRace(RACE_AQUA) and c:IsAbleToRemoveAsCost()
end