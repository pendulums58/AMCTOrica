--조 여환무장【도미네이터】
function c101234021.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101234021.pfilter1,c101234021.pfilter2,1,1)
	c:EnableReviveLimit()
	--특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101234020)
	e1:SetTarget(c101234021.sptg)
	e1:SetOperation(c101234021.spop)
	c:RegisterEffect(e1)
end
function c101234021.pfilter1(c)
	return c:IsSetCard(0x611) 
end
function c101234021.pfilter2(c)
	return c:IsSetCard(0x611) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c101234021.filter2(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x611) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101234021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101234021.filter2,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SelectTarget(tp,c101234008.filter2,tp,LOCATION_SZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101234021.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if g:IsRelateToEffect(e) then
		if g:GetOriginalType()&TYPE_FUSION==TYPE_FUSION then return Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end