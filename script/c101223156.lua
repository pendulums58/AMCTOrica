--알메리아의 지배력
function c101223156.initial_effect(c)
	c:SetUniqueOnField(1,0,101223156)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223156.actcon)
	c:RegisterEffect(e1)
	--소환시 발동 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c101223156.limop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetOperation(c101223156.limop2)
	c:RegisterEffect(e3)
	--의식 서치
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cyan.dhcost(1))
	e4:SetTarget(c101223156.thtg)
	e4:SetOperation(c101223156.thop)
	c:RegisterEffect(e4)
	--회복
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCondition(c101223156.recon2)
	e5:SetTarget(c101223156.retg2)
	e5:SetOperation(c101223156.reop2)
	c:RegisterEffect(e5)
end
function c101223156.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223156.chk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223156.chk(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c101223156.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c101223156.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(101223156,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c101223156.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101223156.chainlm(e,ep,tp)
	return ep==tp
end
function c101223156.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(101223156)
	e:Reset()
end
function c101223156.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(101223156)~=0 then
		Duel.SetChainLimitTillChainEnd(c101223156.chainlm)
	end
end
function c101223156.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223156.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c101223156.thfilter(c,tp)
	local ty=TYPE_MONSTER
	if Duel.IsExistingMatchingCard(c101223156.chk,tp,LOCATION_MZONE,0,1,nil) then ty=ty+TYPE_SPELL end
	return c:IsType(ty) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c101223156.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c101223156.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
	end
end
function c101223156.cfilter2(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c101223156.recon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223156.cfilter2,1,nil,tp)
end
function c101223156.retg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c101223156.reop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
