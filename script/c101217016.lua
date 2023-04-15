--에고파인더 템퍼런스
function c101217016.initial_effect(c)
	--소환
	aux.AddXyzProcedure(c,c101217016.ovfilter1,4,2,c101217016.ovfilter2,aux.Stringid(101217016,0),2,c101217016.xyzop)
	c:EnableReviveLimit()
	
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101217016,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101217016.cost)
	e1:SetTarget(c101217016.target)
	e1:SetOperation(c101217016.operation)
	c:RegisterEffect(e1)
end
function c101217016.ovfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xef7)
end
function c101217016.ovfilter2(c)
	return c:IsFaceup() and c:IsCode(101217000)
end
function c101217016.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101217016)==0 end
	Duel.RegisterFlagEffect(tp,101217016,RESET_PHASE+PHASE_END,0,1)
	return true
end
function c101217016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101217016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c101217016.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	else
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	end
end