--스토리텔러-월하의 가희
function c103550000.initial_effect(c)
	--지속마법 구현
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,103550000)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c103550000.sptg1)
	e1:SetOperation(c103550000.spop1)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,103550000)
	e3:SetCost(c103550000.thcost)
	cyan.JustSearch(e3,LOCATION_DECK,Card.IsSetCard,0x64a)
	c:RegisterEffect(e3)
end
function c103550000.filter(c,e,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function c103550000.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c103550000.filter(chkc,e,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,chkc:GetCode(),Duel.ReadCard(chkc,CARDDATA_SETCODE),TYPES_NORMAL_TUNER_MONSTER,500,500,3,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c103550000.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c103550000.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c103550000.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not tc:IsRelateToEffect(e) then return end
	Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
	tc:AddStoryTellerAttribute(e:GetHandler())
	Duel.SpecialSummonComplete()
end
function c103550000.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c103550000.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c103550000.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c103550000.rmfilter(c)
	return c:IsSetCard(0x64a) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
		and c:IsAbleToRemoveAsCost()
end