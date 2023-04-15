--LEM(링크 익스텐드 매직)-에스트 루나피스
function c101213015.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101213015.target)
	e1:SetOperation(c101213015.activate)
	c:RegisterEffect(e1)
end
function c101213015.filter1(c,e,tp)
	local rk=c:GetLink()
	return c:IsFaceup() and c:IsSetCard(0xef3) and c:IsType(TYPE_LINK)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.IsExistingMatchingCard(c101213015.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+2)
end
function c101213015.filter2(c,e,tp,mc,rk)
	return c:GetLink()==rk and c:IsSetCard(0xef3) and mc:IsCanBeLinkMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c101213015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101213015.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c101213015.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101213015.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101213015.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101213015.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetLink()+2)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)
		Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
	local g=Duel.GetMatchingGroup(c101213015.cfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetClassCount(Card.GetCode)>=5 and Duel.SelectYesNo(tp,aux.Stringid(101213015,0)) then 
		local zone=sc:GetLinkedZone(tc)
		if zone==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101213015.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end
function c101213015.cfilter(c)
	return c:IsSetCard(0xef3) and c:IsType(TYPE_MONSTER)
end
function c101213015.spfilter0(c,e,tp)
	return c:IsSetCard(0xef3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101213015.spfilter1(c,e,tp,zone)
	return c:IsSetCard(0xef3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
