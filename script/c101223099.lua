--역사의 관찰자
function c101223099.initial_effect(c)
	--엑시즈 소재
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--종족변경
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101223099,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101223099.target)
	e1:SetOperation(c101223099.operation)
	c:RegisterEffect(e1)
	--같은 종족 서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(101223099,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101223099.Tcost)
	e2:SetTarget(c101223099.Ttarget)
	e2:SetOperation(c101223099.Toperation)
	c:RegisterEffect(e2)
end
--1번 효과
function c101223099.filter(c)
	return c:IsFaceup() and not c:IsCode(101223099)
end
function c101223099.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101223099.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101223099.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101223099.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL-g:GetFirst():GetRace())
	e:SetLabel(rc)
end
function c101223099.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.FromCards(c)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		g:AddCard(tc)
	end
	g=g:Filter(Card.IsFaceup,nil)
	for oc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(e:GetLabel())
		oc:RegisterEffect(e1)
	end
end
--2번 효과
function c101223099.Tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c101223099.Ttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101223099.Tfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetRace()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101223099.Toperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c101223099.thcon)
		e1:SetOperation(c101223099.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101223099.Tfilter(c,race)
	return c:IsRace(race) and c:IsAbleToHand()
end
function c101223099.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c101223099.Tfilter),tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetRace())
end
function c101223099.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(101223099,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101223099.Tfilter),tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetRace())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(c101223099.aclimit)
			e1:SetLabel(g:GetFirst():GetCode())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c101223099.aclimit(e,re,tp)
    return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end