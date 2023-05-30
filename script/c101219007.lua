--라디언트 라이트
local s,id=GetID()
function s.initial_effect(c)
	--패발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetCondition(cyan.selfpubcon)
	c:RegisterEffect(e1)
	--무효화
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	--공개 발동
	local e3=e2:Clone()
	e3:SetCondition(s.negcon1)
	e3:SetTarget(s.target(e3))
	c:RegisterEffect(e3)
	--서치
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGOTY_TOHAND)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,{1,id})
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(s.confilter1,tp,LOCATION_HAND,0,1,nil))
		and not e:GetHandler():IsPublic()
end
function s.negcon1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(s.confilter1,tp,LOCATION_HAND,0,1,nil))
		and e:GetHandler():IsPublic()
end
function s.confilter(c)
	return c:IsSetCard(SETCARD_RADIANT) and c:IsType(TYPE_RITUAL)
end
function s.confilter1(c)
	return c:IsSetCard(SETCARD_RADIANT) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsPublic()
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c:IsFaceup() and not c:IsDisabled() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsNegatable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsNegatable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
end
function negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end			
		tc=g:GetNext()
	end
end
function s.target(eff)
	local tg = eff:GetTarget()
	return function(e,...)
		local ret = tg(e,...)
		if ret then return ret end
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			Duel.SetChainLimit(s.chlimit)
		end
	end
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGOTY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
	end
end
function s.thfilter(c)
	return c:IsSetCard(SETCARD_RADIANT) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end