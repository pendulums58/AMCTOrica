--환영검객 치누크
function c101255014.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c101255014.unlockeff)	
	--바운스
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101255014.tg)
	e1:SetOperation(c101255014.op)
	c:RegisterEffect(e1)
end
function c103551014.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c103551014.thcon)
	e1:SetOperation(c101255014.ccop)
	Duel.RegisterEffect(e1,tp)	
end
function c101255014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101255014.chk,1,nil) and rp==1-tp
end
function c101255014.chk(c)
	return c:IsSetCard(0x627) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
end
function c101255014.ccop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101255014)
	local sword_code={101255009,101255010}
	math.randomseed(os.time())
	local code=sword_code[math.random(1,#sword_code)]
	local dct=Duel.CreateToken(code)
	Duel.SendtoHand(dct,nil,REASON_EFFECT)
	Duel.ConfirmCards(dct,1-tp)
end
function c101255014.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(c101255014.msfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local tc=Duel.SelectTarget(tp,c101255014.msfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local tc1=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,0,1,1,nil)
	tc:Merge(tc1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,tc:GetCount(),tp,LOCATION_ONFIELD)
end
function c101255014.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if ct==1 and Duel.IsExistingMatchingCard(c101255014.thfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(101255014,0)) then
			local g1=Duel.SelectMatchingCard(tp,c101255014.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoHand(g1,nil,REASON_EFFECT)
				Duel.ConfirmCards(g1,1-tp)
			end
		end
		if ct==0 then
			local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g2:GetCount()>0 then
				Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function c101255014.msfilter(c)
	return c:IsSetCard(0x627) and c:IsFaceup()
end
function c101255014.thfilter(c)
	return c:IsSetCard(0x627) and c:IsAbleToHand()
end