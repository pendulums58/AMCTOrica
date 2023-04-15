--보우엔쿄 #이스트 스타일
function c101254006.initial_effect(c)
	--덱갈이
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c101254006.distarget)
	e1:SetCountLimit(1,101254006)
	e1:SetOperation(c101254006.disop)
	c:RegisterEffect(e1)
	--묘지 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101254106)
	e2:SetCondition(c101254006.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101254006.thtg)
	e2:SetOperation(c101254006.thop)
	c:RegisterEffect(e2)	
end
function c101254006.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c101254006.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct+1) and ct>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,nil)
end
function c101254006.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x626)
end
function c101254006.disop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c101254006.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	local g=Duel.GetDecktopGroup(1-tp,ct)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>2 and Duel.IsExistingMatchingCard(c101254006.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101254006,0)) then
		local tc=Duel.SelectMatchingCard(tp,c101254006.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c101254006.tgfilter(c)
	return c:IsSetCard(0x626) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101254006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<2 and aux.exccon(e)
end
function c101254006.thfilter(c)
	return c:IsSetCard(0x626) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c101254006.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101254006.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function c101254006.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c101254006.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if tc:GetCount()>0 and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<2 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end