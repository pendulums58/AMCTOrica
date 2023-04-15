--만물 관리록
function c101273006.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REVERSE_DECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101234026,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c101273006.discon)
	e3:SetTarget(c101273006.thtg)
	e3:SetOperation(c101273006.thop)
	c:RegisterEffect(e3)
end
function c101273006.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CHAINING) and Duel.IsPlayerCanDiscardDeck(tp,1)
end
function c101273006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c101273006.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x645) and tc:IsType(TYPE_MONSTER) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		local m=_G["c"..tc:GetOriginalCode()]
		local te=m.discard_effect
		if not te then return end
		local tg=te:GetTarget()
		local chk=0
		if not tg then chk=1 end
		if tg and tg(e,tp,eg,ep,ev,re,r,rp,0) then
			chk=1
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
		if chk==1 then
		
		end
		local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
end		
end