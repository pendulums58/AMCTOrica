--만물.EXE 오니마루 헤드
function c101273011.initial_effect(c)
	  -- 패 버리고 서치 + 1 드로 
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(101273011,0))
   e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetRange(LOCATION_HAND)
   e1:SetCountLimit(1,101273011)
   e1:SetCost(c101273011.cost)
   e1:SetTarget(c101273011.target)
   e1:SetOperation(c101273011.thop)
   c:RegisterEffect(e1)
   c101273011.discard_effect=e1
   --추가 일소권
   local e2=Effect.CreateEffect(c)
   e2:SetDescription(aux.Stringid(101273011,1))
   e2:SetType(EFFECT_TYPE_IGNITION)
   e2:SetRange(LOCATION_GRAVE)
   e2:SetCountLimit(1,101274011)
   e2:SetCost(aux.bfgcost)
   e2:SetTarget(c101273011.thtg)
   e2:SetOperation(c101273011.thop2)
   c:RegisterEffect(e2)
end
function c101273011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c101273011.target(e,tp,eg,ep,ev,re,r,rp,chk)
   	if chk==0 then return Duel.IsExistingMatchingCard(c101273011.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101273011.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_REVEAL) 
end
function c101273011.thfilter(c)
	return c:IsSetCard(0x645,0x64c) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c101273011.filter(c,e,tp)    
   return c:IsSetCard(0x645) and  c:IsType(TYPE_MONSTER)
end
function c101273011.thop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end Duel.IsPlayerCanDiscardDeck(tp,1)
   Duel.ConfirmDecktop(tp,1) 
   local g=Duel.GetDecktopGroup(tp,1)
   local tc=g:GetFirst() 
   if tc:IsSetCard(0x645) and tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  then  
	local g=Duel.SelectMatchingCard(tp,c101273011.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.Draw(tp,1,REASON_EFFECT)  
		end
   end
end
function c101273011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101273011.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101273011.thop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(101273011,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x645))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,101273011,RESET_PHASE+PHASE_END,0,1)
end
