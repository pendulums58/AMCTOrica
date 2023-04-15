--마브로×플래그마타
function c101265000.initial_effect(c)
	--일 / 특소시 공통효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101265000,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101265000)
	e1:SetTarget(c101265000.target)
	e1:SetOperation(c101265000.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	--공통효과 추가
	cyan.AddFragmataEffect(c)
end
function c101265000.filter(c)
	return c:IsSetCard(0x633) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c101265000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101265000.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101265000.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101265000.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetCurrentPhase()==PHASE_END and Duel.SelectYesNo(tp,aux.Stringid(101265000,0)) then
			Duel.DecreaseMaxHandSize(e:GetHandler(),tp,1)
		end
	end
end