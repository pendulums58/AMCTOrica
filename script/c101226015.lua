--신살마녀 글록시니아
function c101226015.initial_effect(c)
	--공격력 상승
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101226015,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCost(c101226015.atkcost)
	e1:SetTarget(c101226015.atktg)
	e1:SetOperation(c101226015.atkop1)
	c:RegisterEffect(e1)	
	--소재가 되면 발동하는 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101226015,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,101226015)
	e2:SetCost(cyan.htgcost(1))
	e2:SetCondition(c101226015.spcon1)
	e2:SetTarget(c101226015.thtg)
	e2:SetOperation(c101226015.thop)
	c:RegisterEffect(e2)	
end
function c101226015.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101226015.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x612)
end
function c101226015.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c101226015.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101226015.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101226015.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101226015.atkop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(2)
		tc:RegisterEffect(e2)
	end
end
function c101226015.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_ACCESS and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c101226015.chainlm(e,rp,tp)
	return tp==rp
end
function c101226015.filter(c)
	return c:IsSetCard(0x612) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c101226015.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c101226015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101226015.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101226015.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetChainLimit(c101226015.chainlm)
end
function c101226015.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end