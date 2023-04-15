--프라시×플래그마타
function c101265002.initial_effect(c)
	--덤핑 및 공통효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101265002,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101265002)
	e1:SetTarget(c101265002.target)
	e1:SetOperation(c101265002.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	cyan.AddFragmataEffect(c)
end
function c101265002.tgfilter(c)
	return c:IsSetCard(0x633) and c:IsAbleToGrave()
end
function c101265002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101265002.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101265002.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101265002.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if Duel.GetCurrentPhase()==PHASE_END and Duel.SelectYesNo(tp,aux.Stringid(101265000,0)) then
			Duel.DecreaseMaxHandSize(e:GetHandler(),tp,1)
		end
	end
end
