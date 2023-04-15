
function c101271012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101271012)
    e1:SetHintTiming(TIMING_DESTROY)
    e1:SetTarget(c101271012.target)
    e1:SetOperation(c101271012.activate)
    c:RegisterEffect(e1)
end
function c101271012.filter1(c,e,tp)
    local rk=c:GetLink()
    return c:IsSetCard(0x642) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.IsExistingMatchingCard(c101271012.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
end
function c101271012.filter2(c,e,tp,mc,rk)
    return c:GetLink()==rk and c:IsSetCard(0x642) and mc:IsCanBeLinkMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c101271012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101271012.filter1(chkc,e,tp) end
    if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c101271012.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c101271012.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_EXTRA)
end
function c101271012.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
    if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c101271012.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetLink()+1)
    local sc=g:GetFirst()
    if sc then
        sc:SetMaterial(Group.FromCards(tc))
        Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)
        Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
        sc:CompleteProcedure()
    end
end