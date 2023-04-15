--딜레탕트의 선구자
function c111331001.initial_effect(c)
--패 특소
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111331001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,111331001)
	e1:SetCondition(c111331001.spcon1)
	e1:SetTarget(c111331001.sptg1)
	e1:SetOperation(c111331001.spop1)
	c:RegisterEffect(e1)
--묘지 특소	
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
--패 확인	
	local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCondition(c111331001.hdcon)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e3)
end
--특소
function c111331001.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c111331001.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c111331001.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--패 확인
function c111331001.hdcon(e)
    local c=e:GetHandler()
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(Card.IsOwner,tp,0,LOCATION_MZONE,1,nil,tp)
end