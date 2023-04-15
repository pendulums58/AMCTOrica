--만물 동결사
function c101273002.initial_effect(c)
	--무효 하는 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101273002,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101273002)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101273002.condition)
	e1:SetCost(c101273002.cost)
	e1:SetTarget(c101273002.target)
	e1:SetOperation(c101273002.thop)
	c:RegisterEffect(e1)
	c101273002.discard_effect=e1
	--sort
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101273002,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101274002)
	e2:SetTarget(c101273002.sdtg)
	e2:SetOperation(c101273002.sdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101273002.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer() and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c101273002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
   if chk==0 then return c:IsDiscardable() end
   Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c101273002.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
   if chkc then return chkc:IsLocation() and c101273002.nfilter(chkc) end
   if chk==0 then return Duel.IsExistingTarget(c101273002.nfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
   Duel.SelectTarget(tp,c101273002.nfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101273002.filter(c,e,tp)
   return c:IsSetCard(0x645) and c:IsType(TYPE_MONSTER)
end
function c101273002.thop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
   Duel.ConfirmDecktop(tp,1)
   local g=Duel.GetDecktopGroup(tp,1)
   local tc=g:GetFirst()
   if tc:IsSetCard(0x645) and tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  then  
   Duel.DisableShuffleCheck()
   local c=e:GetHandler()
   local tc=Duel.GetFirstTarget()
   if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and not tc:IsDisabled() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		end
   end
end
function c101273002.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>6 end
end
function c101273002.sdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,tp,5)
end