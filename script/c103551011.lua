--아이라식 환성검기
function c103551011.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,103551011)
	e1:SetCost(c103551011.cost)
	e1:SetTarget(c103551011.target)
	e1:SetOperation(c103551011.operation)
	c:RegisterEffect(e1)
	--패특소
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCost(c103551011.spcost)
	e2:SetCondition(c103551011.spcon)
	e2:SetTarget(c103551011.sptg)
	e2:SetOperation(c103551011.spop)
	c:RegisterEffect(e2)
end
function c103551011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103551011.costfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c103551011.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c103551011.costfilter(c)
	return (c:IsSetCard(0x64b) or c:IsType(TYPE_EQUIP)) and c:IsAbleToGraveAsCost()
end
function c103551011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103551011.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c103551011.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c103551011.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local g1=Duel.SelectMatchingCard(tp,c103551011.thfilter1,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst())
		if g1:GetCount()>0 then
			g:Merge(g1)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(g,1-tp)
		end
	end
end
function c103551011.thfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and Duel.IsExistingMatchingCard(c103551011.thfilter1,tp,LOCATION_DECK,0,1,nil,c)
end
function c103551011.thfilter1(c,tc)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x64b) and tc:CheckEquipTarget(c)
end
function c103551011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c103551011.costfilter1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c103551011.costfilter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then g:AddCard(e:GetHandler()) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c103551011.costfilter1(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function c103551011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c103551011.thchk,1,nil,tp)	
end
function c103551011.thchk(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_PAIRING) and c:IsPreviousControler(tp)
end
function c103551011.filter(c,e,tp)
	return c:IsSetCard(0x64b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c103551011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c103551011.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c103551011.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c103551011.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
