--로스트스타 가이던스
function c111310106.initial_effect(c)
	--2중택1
	--액세스 대상
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,111310006)
	e1:SetTarget(c111310006.sptg)
	e1:SetOperation(c111310006.spop)
	c:RegisterEffect(e1)
	--페어링 대상
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,111310006)
	e2:SetTarget(c111310006.sptg1)
	e2:SetOperation(c111310006.spop1)
	c:RegisterEffect(e2)
end
function c111310006.filter(c,e,tp)
	local ad=c:GetAdmin()
	return ad and Duel.IsExistingMatchingCard(c111310006.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ad)
end
function c111310006.spfilter(c,e,tp,ad)
	return c:IsRace(ad:GetRace()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c111310006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c111310006.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c111310006.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c111310006.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c111310006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetAdmin() then
		local g=Duel.SelectMatchingCard(tp,c111310006.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetAdmin())
		if g:GetCount()>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c111310006.filter1(c,e,tp)
	local pr=c:GetPair()
	return pr:IsExists(Card.IsType,1,nil,TYPE_PAIRING) and Duel.IsExistingMatchingCard(c111310006.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c111310006.spfilter1(c,e,tp,ad)
	return c:IsAttribute(ad:GetAttribute()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c111310006.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c111310006.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c111310006.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c111310006.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c111310006.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c111310006.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
		if g:GetCount()>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end