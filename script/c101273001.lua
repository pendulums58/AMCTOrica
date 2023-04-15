--만물 기행사
function c101273001.initial_effect(c)
		--무효 하는 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101273001,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101273001)
	e1:SetHintTiming(0,0x1e0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101273001.condition)
	e1:SetCost(c101273001.cost)
	e1:SetTarget(c101273001.target)
	e1:SetOperation(c101273001.thop)
	c:RegisterEffect(e1)
	c101273001.discard_effect=e1
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101273001,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101274001)
	e2:SetTarget(c101273001.thtg)
	e2:SetOperation(c101273001.thop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101273001.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer() and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c101273001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
   if chk==0 then return c:IsDiscardable() end
   Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c101273001.filter(c,e,tp)
	return c:IsFaceup() and c:GetLevel()>0
end
function c101273001.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101273001.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101273001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101273001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101273001.thop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
   Duel.ConfirmDecktop(tp,1)
   local g=Duel.GetDecktopGroup(tp,1)
   local tc=g:GetFirst()
   if tc:IsSetCard(0x645) and tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  then  
   Duel.DisableShuffleCheck()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local lv=Duel.SelectOption(tp,aux.Stringid(101273001,2),aux.Stringid(101273001,3),aux.Stringid(101273001,4),aux.Stringid(101273001,5))
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(lv+1)
		tc:RegisterEffect(e1)
	end
end
end
function c101273001.tdfilter(c)
	return c:IsSetCard(0x645) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c101273001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101273001.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101273001.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101273001.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101273001.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsExtraDeckMonster()
			or Duel.SelectOption(tp,aux.Stringid(101273001,2),aux.Stringid(101273001,3))==0 then
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		else
			Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
		end
	end
end