--신살마녀의 서원
function c101226023.initial_effect(c)
	--비대상 제외
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101226023,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101226023.rmcost)
	e1:SetTarget(c101226023.rmtg)
	e1:SetOperation(c101226023.rmop)
	c:RegisterEffect(e1)	
	--묘지 회수
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCountLimit(1,101226023)
	e2:SetCondition(c101226023.salcon)
	e2:SetTarget(c101226023.saltg)
	e2:SetOperation(c101226023.salop)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function c101226023.cfilter(c)
	local tp=c:GetControler()
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x612) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101226023.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c101226023.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101226023.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x612)
		and Duel.IsExistingMatchingCard(c101226023.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c101226023.rmfilter(c,atk)
	return c:GetAttack()>atk and c:IsAbleToRemove()
end
function c101226023.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c101226023.costfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,c101226023.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	local atk=cg:GetFirst():GetAttack()
	e:SetLabel(atk)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c101226023.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local atk=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c101226023.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,atk)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c101226023.salcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsExistingMatchingCard(c101226023.thcheck,tp,0,LOCATION_MZONE,1,nil)
end
function c101226023.thcheck(c)
	return not Duel.IsExistingMatchingCard(c101226023.atkcheck,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c101226023.atkcheck(c,atk)
	return c:GetAttack()>atk
end
function c101226023.saltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101226023.salop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
