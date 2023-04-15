--스펠슬링어즈 ♣(클로버)
function c101223141.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101223141)
	e1:SetCost(cyan.selfdiscost)
	e1:SetCondition(c101223141.spcon)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsType,TYPE_TUNER)
	c:RegisterEffect(e1)
	if not c101223141.global_check then
		c101223141.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c101223141.checkop)
		Duel.RegisterEffect(ge1,0)
	end	
end
function c101223141.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,101223141)==3 and rp==1-tp
end
function c101223141.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_SPELL) then
		Duel.RegisterFlagEffect(rp,101223141,RESET_PHASE+PHASE_END,0,1)
	end
end