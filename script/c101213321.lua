--시계탑 방위견습생
function c101213321.initial_effect(c)
	--덱에서 시계탑 특소
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101213302,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101213302)
	e1:SetCondition(c101213321.condition)
	e1:SetTarget(c101213321.target)
	e1:SetOperation(c101213321.operation)
	c:RegisterEffect(e1)
	--덱에서 시계탑 서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101213302,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c101213321.condition)
	e2:SetCountLimit(1,101213302)
	e2:SetTarget(c101213321.target1)
	e2:SetOperation(c101213321.operation1)
	c:RegisterEffect(e2)
end
function c101213321.cfilter(c)
	return c:IsFaceup() and c:IsCode(75041269)
end
function c101213321.spfilter(c,e,tp)
	return c:IsSetCard(0x60a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101213321.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101213321.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101213321.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101213321.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101213321.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(c101213321.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return end
	local g=Duel.SelectMatchingCard(tp,c101213321.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101213321.filter(c)
	return c:IsSetCard(0x60a) and c:IsAbleToHand()
end
function c101213321.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213321.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101213321.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101213321.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
