--액세스 모듈라이즈
function c111310115.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c111310115.tg)
	e1:SetOperation(c111310115.op)
	c:RegisterEffect(e1)
end
function c111310115.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp)
		and c111310115.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c111310115.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,c111310115.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,nil,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,nil,LOCATION_HAND)
end
function c111310115.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c111310115.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
		if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
		local g1=Duel.SelectMatchingCard(tp,c111310115.spfiilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc)
		if g1:GetCount()>0 then Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP) end
	end
end
function c111310115.filter(c,e,tp)
	return c:IsType(TYPE_ACCESS) and Duel.IsExistingMatchingCard(c111310115.tgfilter,tp,LOCATON_DECK,0,1,nil,c)
		and Duel.IsExistingMatchingCard(c111310115.spfiler,tp,LOCATION_HAND,0,1,nil,e,tp,c)
end
function c111310115.tgfilter(c,tc)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and (c:IsAttackBelow(tc:GetAttack()-1) or c:IsLevelBelow(tc:GetLevel()-1))
end
function c111310115.spfilter(c,e,tp,tc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
		and (tc:IsAttackBelow(c:GetAttack()-1) or tc:IsLevelBelow(c:GetLevel()-1))
end