--에고파인더 저스티스
function c101217015.initial_effect(c)
	--소환
	aux.AddXyzProcedure(c,c101217015.ovfilter1,4,2,c101217015.ovfilter2,aux.Stringid(101217013,0),2,c101217015.xyzop)
	c:EnableReviveLimit()
	
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101217015,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101217015.cost)
	e1:SetTarget(c101217015.target)
	e1:SetOperation(c101217015.operation)
	c:RegisterEffect(e1)
end
function c101217015.ovfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xef7)
end
function c101217015.ovfilter2(c)
	return c:IsFaceup() and c:IsCode(101217000)
end
function c101217015.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101217015)==0 end
	Duel.RegisterFlagEffect(tp,101217015,RESET_PHASE+PHASE_END,0,1)
	return true
end
function c101217015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101217015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		return h1>0 and h2>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c101217015.operation(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if h1<1 or h2<1 then return end
	local turnp=Duel.GetTurnPlayer()
	Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(turnp,aux.TRUE,turnp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-turnp,g1)
	Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-turnp,aux.TRUE,1-turnp,LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(turnp,1,REASON_EFFECT)
	Duel.Draw(1-turnp,1,REASON_EFFECT)
end