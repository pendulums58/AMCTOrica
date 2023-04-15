--만물 광뢰인
function c101273000.initial_effect(c)
   -- 패 버리고 패특소
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(101273000,0))
   e1:SetCategory(CATEGORY_TOHAND)
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetRange(LOCATION_HAND)
   e1:SetCountLimit(1,101273000)
   e1:SetCost(c101273000.cost)
   e1:SetTarget(c101273000.target)
   e1:SetOperation(c101273000.thop)
   c:RegisterEffect(e1)
	--일소 하면 3장 보고 1 서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101273000,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101274000)
	e2:SetCondition(c101273000.thcon)
	e2:SetTarget(c101273000.thtg)
	e2:SetOperation(c101273000.thop2)
	c:RegisterEffect(e2)
end
function c101273000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
   if chk==0 then return c:IsDiscardable() end 
   Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD) 
end
function c101273000.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 end 
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK) 
end
function c101273000.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_REVEAL) 
end
function c101273000.filter(c,e,tp)    
   return c:IsSetCard(0x645) and  c:IsType(TYPE_MONSTER)
end
function c101273000.thop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end Duel.IsPlayerCanDiscardDeck(tp,1)
   Duel.ConfirmDecktop(tp,1) 
   local g=Duel.GetDecktopGroup(tp,1)
   local tc=g:GetFirst() 
   local spcon=Duel.SelectMatchingCard(tp,c101273000.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
   if tc:IsSetCard(0x645) and tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  then  
		Duel.DisableShuffleCheck()  
		if Duel.SpecialSummon(spcon,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		Duel.Draw(tp,1,REASON_EFFECT)   
end
   end
end
function c101273000.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c101273000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c101273000.thfilter(c)
	return c:IsSetCard(0x645) and c:IsAbleToHand()
end
function c101273000.thop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local ct=g:GetCount()
	if ct>0 and g:FilterCount(c101273000.thfilter,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(101273000,2)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c101273000.thfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		ct=g:GetCount()-sg:GetCount()
	end
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end