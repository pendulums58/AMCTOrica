--에고파인더 휴머니티
function c101217013.initial_effect(c)
	--소환
	aux.AddXyzProcedure(c,c101217013.ovfilter1,4,2,c101217013.ovfilter2,aux.Stringid(101217013,0),2,c101217013.xyzop)
	c:EnableReviveLimit()
	
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101217013.cost)
	e1:SetTarget(c101217013.target)
	e1:SetOperation(c101217013.operation)
	c:RegisterEffect(e1)
end
function c101217013.ovfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xef7)
end
function c101217013.ovfilter2(c)
	return c:IsFaceup() and c:IsCode(101217000)
end
function c101217013.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101217013)==0 end
	Duel.RegisterFlagEffect(tp,101217013,RESET_PHASE+PHASE_END,0,1)
	return true
end
function c101217013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101217013.cfilter(c)
	return c:IsSetCard(0xef7) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c101217013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101217013.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101217013.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101217013.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(101217013,1))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end