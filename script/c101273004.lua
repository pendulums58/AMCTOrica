--만물 천명인
function c101273004.initial_effect(c)
-- 패 버리고 패특소
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(101273004,0))
   e1:SetCategory(CATEGORY_TOHAND)
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetRange(LOCATION_HAND)
   e1:SetCountLimit(1,101273004)
   e1:SetCost(c101273004.cost)
   e1:SetTarget(c101273004.target)
   e1:SetOperation(c101273004.thop)
   c:RegisterEffect(e1)
   c101273004.discard_effect=e1
   --
   local e2=Effect.CreateEffect(c)
   e2:SetDescription(aux.Stringid(101273004,0))
   e2:SetCategory(CATEGORY_DESTROY)
   e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
   e2:SetCountLimit(1,101274004)
   e2:SetCode(EVENT_SPSUMMON_SUCCESS)
   e2:SetCondition(c101273004.descon)
   e2:SetTarget(c101273004.destg1)
   e2:SetOperation(c101273004.desop1)
   c:RegisterEffect(e2)
end
function c101273004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
   if chk==0 then return c:IsDiscardable() end
   Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c101273004.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c101273004.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c101273004.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_REVEAL)
end
function c101273004.filter(c,e,tp)
   return c:IsSetCard(0x645) and  c:IsType(TYPE_MONSTER)
end
function c101273004.thop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
   Duel.ConfirmDecktop(tp,1)
   local g=Duel.GetDecktopGroup(tp,1)
   local tc=g:GetFirst()
   if tc:IsSetCard(0x645) and tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  then  
   Duel.DisableShuffleCheck()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101273004.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101273004.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101273004.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
		local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
end
function c101273004.descon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x645)
end
function c101273004.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101273010,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101273004.desop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101273010,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,101273010)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,101273010))
	e1:SetValue(c101273004.lklimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
end
function c101273004.lklimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end