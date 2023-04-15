--만물 천령인
function c101273003.initial_effect(c)
	--무효 하는 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101273003,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101273003)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101273003.condition)
	e1:SetCost(c101273003.cost)
	e1:SetTarget(c101273003.target)
	e1:SetOperation(c101273003.thop)
	c:RegisterEffect(e1)
	c101273003.discard_effect=e1
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101273003)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101273003.thtg)
	e2:SetOperation(c101273003.thop2)
	c:RegisterEffect(e2)
end
function c101273003.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer() and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c101273003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
   if chk==0 then return c:IsDiscardable() end
   Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c101273003.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
   if chk==0 then return Duel.IsExistingMatchingCard(c101273003.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c101273003.filter(c,e,tp)
   return c:IsSetCard(0x645) and c:IsType(TYPE_MONSTER)
end
function c101273003.thop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
   Duel.ConfirmDecktop(tp,1)
   local g=Duel.GetDecktopGroup(tp,1)
   local tc=g:GetFirst()
   local spcon=Duel.SelectMatchingCard(tp,c101273003.filter,tp,0,1,1,nil,e,tp)
   if tc:IsSetCard(0x645) and tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  then  
   Duel.DisableShuffleCheck()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(tc:GetAttack()/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
		end
	end
end
function c101273003.thfilter(c)
	return c:IsCode(101273006) and c:IsAbleToHand()
end
function c101273003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101273003.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101273003.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101273003.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
