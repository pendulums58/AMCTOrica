--시계탑의 방랑자
function c101213326.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101213326,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101213326)
	e1:SetCost(c101213326.cost)
	e1:SetTarget(c101213326.target)
	e1:SetOperation(c101213326.operation)
	c:RegisterEffect(e1)
	--덱에서 시계탑 특소
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101213326,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101213326)
	e2:SetCondition(c101213326.condition)
	e2:SetTarget(c101213326.target1)
	e2:SetOperation(c101213326.operation1)
	c:RegisterEffect(e2)	
end
function c101213326.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c101213326.filter(c)
	return c:IsCode(CARD_CLOCKTOWER) and c:IsAbleToHand()
end
function c101213326.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213326.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101213326.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c101213326.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c101213326.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x60a) and c:IsType(TYPE_ACCESS+TYPE_PAIRING)
end
function c101213326.spfilter(c,e,tp)
	return c:IsSetCard(0x60a) and c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101213326.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101213326.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101213326.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101213326.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101213326.operation1(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(c101213326.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return end
	local g=Duel.SelectMatchingCard(tp,c101213326.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end