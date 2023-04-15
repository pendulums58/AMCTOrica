--레프코×플래그마타
function c101265001.initial_effect(c)
	--일 / 특소시 공통효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101265001,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101265001)
	e1:SetTarget(c101265001.target)
	e1:SetOperation(c101265001.operation)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	--공통효과 추가
	cyan.AddFragmataEffect(c)
end
function c101265001.filter(c)
	return c:IsSetCard(0x633) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101265001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101265001.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101265001.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101265001.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101265001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if Duel.GetCurrentPhase()==PHASE_END and Duel.SelectYesNo(tp,aux.Stringid(101265000,0)) then
			Duel.DecreaseMaxHandSize(e:GetHandler(),tp,1)
		end
	end
end