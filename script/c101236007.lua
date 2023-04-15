--발할라즈 블렌드
function c101236007.initial_effect(c)
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,101236007)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101236007.target)
	e1:SetOperation(c101236007.activate)
	c:RegisterEffect(e1)
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CHEMICAL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101236907)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101236007.cmtg)
	e2:SetOperation(c101236007.cmop)
	c:RegisterEffect(e2)
end
function c101236007.filter1(c,e,tp)
	return c:IsSetCard(0x658) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101236007.filter2(c)
	return c:IsCode(101236009) and c:IsFaceup()
end
function c101236007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c101236007.filter1,tp,LOCATION_HAND,0,1,nil,e,tp)
		or (Duel.IsExistingMatchingCard(c101236007.filter2,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101236007.filter1,tp,LOCATION_DECK,0,1,nil,e,tp))) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
	if Duel.IsExistingMatchingCard(c101236007.filter2,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101236007.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	end
end
function c101236007.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsExistingMatchingCard(c101236007.filter2,tp,LOCATION_SZONE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101236007.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101236007.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101236007.cmfilter(c)
	return c:IsFaceup() and c:IsCode(101236009)
end
function c101236007.cmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101236007.cmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101236007.cmfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101236007.cmfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101236007.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x658) and c:IsType(TYPE_MONSTER)
end
function c101236007.cmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c101236007.cfilter,tp,LOCATION_MZONE,0,nil)
	yipi.SelectChemical(tp,tc)
	while ct>1 do
		if Duel.SelectYesNo(tp,aux.Stringid(101236007,0)) then
		yipi.SelectChemical(tp,tc)
		ct=ct-1
		else break end
	end
	if Duel.SelectYesNo(tp,aux.Stringid(101236007,1)) then
		yipi.Blend(tc,tp)
	end
end