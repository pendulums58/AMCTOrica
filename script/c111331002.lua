--지나간 기억의 잔류물
function c111331002.initial_effect(c)
--패에 넣기, 특소
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111331002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)	
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,111331002)
	e1:SetCost(c111331002.cost)
	e1:SetTarget(c111331002.target)
	e1:SetOperation(c111331002.operation)
	c:RegisterEffect(e1)	
--무덤 털기
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111331002,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,111331502)
	e2:SetCondition(c111331002.condition2)
	e2:SetTarget(c111331002.target2)
	e2:SetOperation(c111331002.operation2)
	c:RegisterEffect(e2)
end
--패에 넣기
function c111331002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c111331002.filter(c)
	return c:IsSetCard(0x639) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c111331002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c111331002.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c111331002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111331002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEUP)
	end
end
--무덤 털기
function c111331002.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==1-tp and tp==c:GetOwner()
end
function c111331002.filter2(c)
	return c:IsAbleToHand()
end
function c111331002.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c111331002.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c111331002.filter2,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.SelectTarget(tp,c111331002.filter2,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,1-tp,LOCATION_GRAVE)
end
function c111331002.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
	end
end