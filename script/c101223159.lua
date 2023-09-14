--이드의 지배력
function c101223159.initial_effect(c)
	c:SetUniqueOnField(1,0,101223159)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223159.actcon)
	c:RegisterEffect(e1)
	--파괴 대신
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c101223159.reptg)
	e2:SetValue(c101223159.repval)
	e2:SetOperation(c101223159.repop)
	c:RegisterEffect(e2)
	--드로우
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c101223159.drcost)
	e3:SetCountLimit(1)
	e3:SetTarget(c101223159.drtg)
	e3:SetOperation(c101223159.drop)
	c:RegisterEffect(e3)
	--데미지 경감
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c101223159.rmcon)
	e5:SetOperation(c101223159.rmop)	
	c:RegisterEffect(e5)
end
function c101223159.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223159.chk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223159.chk(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c101223159.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c101223159.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101223159.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local g=eg:Filter(c101223159.repfilter,nil,tp)
		Duel.SetTargetCard(g)
		return true
	else return false end
end
function c101223159.repval(e,c)
	return c101223159.repfilter(c,e:GetHandlerPlayer())
end
function c101223159.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>0 then Duel.Hint(HINT_CARD,0,101223159) end
	local tc=g:GetFirst()
	while tc do
		tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		tc=g:GetNext()
	end
end
function c101223159.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT) end
	Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_COST)	
end
function c101223159.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		or (Duel.IsExistingMatchingCard(c101223159.chk,tp,LOCATION_MZONE,0,2,nil)
			and Duel.IsExistingMatchingCard(c101223159.thfilter,tp,LOCATION_DECK,0,1,nil,tp)) end
	if Duel.IsExistingMatchingCard(c101223159.chk,tp,LOCATION_MZONE,0,2,nil)
			and Duel.IsExistingMatchingCard(c101223159.thfilter,tp,LOCATION_DECK,0,1,nil,tp) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101223159.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c101223159.chk,tp,LOCATION_MZONE,0,2,nil)
			and Duel.IsExistingMatchingCard(c101223159.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(101223159,0)) then
		local g=Duel.SelectMatchingCard(tp,c101223159.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(g,1-tp)
		end
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end	
	
end
function c101223159.thfilter(c,tp)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and
		Duel.IsExistingMatchingCard(c101223159.thchk,tp,LOCATION_MZONE,0,1,nil,c)
end
function c101223159.thchk(c,tc)
	return c:IsSetCardList(tc) and c:IsType(TYPE_XYZ) and c:IsFaceup()	
end
function c101223159.cfilter2(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c101223159.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223159.cfilter2,1,nil,tp)
end
function c101223159.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetValue(c101223159.damval)
	Duel.RegisterEffect(e4,tp)
end
function c101223159.damval(e,re,val,r,rp,rc)
	return val-500
end