--원천, 제간타
function c101223034.initial_effect(c)
	--단짝 세팅
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_DECK)
	e0:SetTarget(c101223034.comptg)
	e0:SetOperation(c101223034.compop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1)
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,101223034)
	e2:SetCost(cyan.selfdiscost)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101223034.tg)
	e2:SetOperation(c101223034.op)
	c:RegisterEffect(e2)
end
function c101223034.comptg(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,COMPANION_COMPLETE)
		and not Duel.IsExistingMatchingCard(c101223034.cpfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp)
		and Duel.GetTurnCount()==1 end
end
function c101223034.cpfilter(c,tp)
	return Duel.IsExistingMatchingCard(c101223034.smfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,c)
end
function c101223034.smfilter(c,tc)
	return c:IsAttribute(tc:GetAttribute()) and c:IsRace(tc:GetRace()) and not c:IsCode(tc:GetCode())
end
function c101223034.compop(e,tp,ep,eg,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,COMPANION_COMPLETE) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(101223034,0)) then
		cyan.companiontheffect(c)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(COMPANION_COMPLETE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
		if not c:IsLocation(LOCATION_HAND) then 
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end		
	end
end
function c101223034.tg(e,tp,ep,eg,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101223034.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101223034.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,c101223034.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)	
end
function c101223034.tgfilter(c,tp)
	return Duel.IsExistingMatchingCard(c101223034.thfilter,tp,LOCATION_GRAVE,0,1,nil,c)
end
function c101223034.thfilter(c,tc)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
		and (
		(c:IsRace(tc:GetRace()) and not c:IsAttribute(tc:GetAttribute()))
			or (c:IsAttribute(tc:GetAttribute()) and not c:IsRace(tc:GetRace()))
			)			
end
function c101223034.op(e,tp,ep,eg,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c101223034.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end