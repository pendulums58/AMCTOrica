--시계탑 방위지원대
function c101213325.initial_effect(c)
	--패 발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c101213325.cost)
	e1:SetCondition(c101213325.condition)
	e1:SetTarget(c101213325.twtg)
	e1:SetOperation(c101213325.twop)
	c:RegisterEffect(e1)
	--만종 회수
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101213325,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101213325.thtg)
	e2:SetOperation(c101213325.thop)
	c:RegisterEffect(e2)	
end
function c101213325.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101213325.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil and at:IsOnField() and at:GetAttack()>=Duel.GetLP(tp)
end
function c101213325.filter(c,tp)
	return c:IsCode(CARD_CLOCKTOWER) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c101213325.twtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213325.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetChainLimit(c101213325.chainlm)
end
function c101213325.chainlm(e,rp,tp)
	return tp==rp
end
function c101213325.twop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101213325.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		local b2=te:IsActivatable(tp,true,true)
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		tc:AddCounter(0x1b,4)
	end
end
function c101213325.filter1(c)
	return c:IsCode(101213309) and c:IsAbleToHand()
end
function c101213325.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c101213325.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101213325.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101213325.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetChainLimit(c101213325.chainlm)
end
function c101213325.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end