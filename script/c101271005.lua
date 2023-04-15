--월하찬가 - 달을 향해 노래하라
function c101271005.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x642),2,2)
    c:EnableReviveLimit()
    --링크 소환 성공 시 묘지에서 1장 특수 소환
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(101271005,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,101271005)
    e1:SetCondition(c101271005.spcon)
    e1:SetTarget(c101271005.sptg)
    e1:SetOperation(c101271005.spop)
    c:RegisterEffect(e1)
	--1번 / 3번 / 5번 열에 있을 때 발동 가능한 슈팅 스타
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(63180841,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
	e2:SetCondition(c101271005.atkcon)
    e2:SetCondition(c101271005.atkcon)
    e2:SetOperation(c101271005.atkop)
    c:RegisterEffect(e2)
end
--1번 효과 구현
function c101271005.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101271005.spfilter(c,e,tp)
    return c:IsSetCard(0x642) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101271005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101271005.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c101271005.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c101271005.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101271005.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
--2번 효과 구현
function c101271005.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and (c:GetSequence()==0 or c:GetSequence()==2 or c:GetSequence()==4) and Duel.GetAttacker():IsControler(1-tp)
end
function c101271005.actfilter(c)
    return c:IsFaceup() and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
end
function c101271005.atkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateAttack()
end