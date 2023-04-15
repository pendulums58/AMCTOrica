--발할라(Va-11 Hall-A)의 바텐더 질
function c101236000.initial_effect(c)
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101236000,4))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101236000)
	e1:SetTarget(c101236000.target)
	e1:SetOperation(c101236000.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--2번 효과
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101236000,5))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET,EFFECT_FLAG2_CHEMICAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101236000.cmtg)
	e3:SetOperation(c101236000.cmop)
	c:RegisterEffect(e3)
end
function c101236000.filter1(c)
	return c:IsSetCard(0x659) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c101236000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101236000.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101236000.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101236000.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101236000.cmfilter(c)
	return c:IsFaceup() and c:IsCode(101236009)
end
function c101236000.cmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101236000.cmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101236000.cmfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101236000.cmfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101236000.cmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	yipi.SelectChemical(tp,tc)
end