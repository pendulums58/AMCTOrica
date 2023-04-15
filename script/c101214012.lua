--스카이워커즈 이클립스
function c101214012.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101214012.cost)
	e1:SetOperation(c101214012.activate)
	c:RegisterEffect(e1)
	--패에서도 발동 가능
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c101214012.handcon)
	c:RegisterEffect(e2)
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c101214012.thcon)
	e3:SetCost(c101214012.thcost)
	e3:SetTarget(c101214012.thtg)
	e3:SetOperation(c101214012.thop)
	c:RegisterEffect(e3)	
end
function c101214012.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c101214012.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c101214012.filter(c)
	return c:IsFaceup() and c:GetLevel()>11 and c:IsSetCard(0xef5)
end
function c101214012.cfilter(c)
	return c:IsSetCard(0xef5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c101214012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101214012.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101214012.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101214012.filter2(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c101214012.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101214012.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetLevel())
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local lv=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if lv:GetSum(Card.GetLevel)>=100 then
		local db=Duel.SelectMatchingCard(tp,c101214012.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if db:GetCount()>0 then
			tc1=db:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(tc1:GetLevel())
			tc1:RegisterEffect(e1)
		end
	end
	
end
function c101214012.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xef5) and c:GetLevel()>=20 
end
function c101214012.thcon(e,c)
	return Duel.IsExistingMatchingCard(c101214012.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c101214012.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101214012.thfilter(c)
	return c:IsSetCard(0xef5) and c:IsAbleToHand()
end
function c101214012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101214012.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101214012.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101214012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end