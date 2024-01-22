--주문추적자, 루트리
function c101223110.initial_effect(c)
	--단짝 세팅
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_DECK)
	e0:SetTarget(c101223110.comptg)
	e0:SetOperation(c101223110.compop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1)
	--효과 복사
	local e2=Effect.CreateEffect(c)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cyan.dhcost(1))
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c101223110.condition)
	e2:SetTarget(c101223110.target)
	e2:SetOperation(c101223110.activate)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	c:RegisterEffect(e2)
end
function c101223110.comptg(e,tp,ep,eg,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(p,COMPANION_COMPLETE)
		and not Duel.IsExistingMatchingCard(c101223110.chk,p,LOCATION_DECK+LOCATION_HAND,0,1,nil,p)
		and Duel.GetTurnCount()==1 end
end
function c101223110.chk(c,tp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,c:GetCode())
end
function c101223110.compop(e,tp,ep,eg,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(p,COMPANION_COMPLETE) then return end
	if Duel.SelectYesNo(p,aux.Stringid(101223110,0)) then
		cyan.companiontheffect(c)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(COMPANION_COMPLETE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,p)
		if not c:IsLocation(LOCATION_HAND) then 
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end		
	end
end
function c101223110.condition(e,tp,eg,ep,ev,re,r,rp)
	local ty=re:GetActiveType()
	return (ty==TYPE_SPELL or ty==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function c101223110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ftg=re:GetTarget()
	if chkc then return ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk) end
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c101223110.activate(e,tp,eg,ep,ev,re,r,rp)
	local fop=re:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
