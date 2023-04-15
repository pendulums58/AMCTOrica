--래바이브 리사이클러
c111310071.AccessMonsterAttribute=true
function c111310071.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()	
	--에메랄
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310071,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310071.drcon)
	e1:SetTarget(c111310071.drtg)
	e1:SetOperation(c111310071.drop)
	c:RegisterEffect(e1)
	--드로우
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310071,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c111310071.drcon1)
	e2:SetCost(c111310071.drcost)
	e2:SetTarget(c111310071.drtg1)
	e2:SetOperation(c111310071.drop1)
	c:RegisterEffect(e2)
end
function c111310071.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310071.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ad=e:GetHandler():GetAdmin()
	if chkc then return ad and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c111310071.filter1(chkc,ad) end
	if chk==0 then return ad and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c111310071.filter1,tp,LOCATION_GRAVE,0,3,nil,ad) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c111310071.filter1,tp,LOCATION_GRAVE,0,3,3,nil,ad)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c111310071.filter1(c,ad)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and (c:IsRace(ad:GetRace()) or c:IsAttribute(ad:GetAttribute()))
end
function c111310071.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c111310071.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation(LOCATION_ONFIELD)
end
function c111310071.cfilter(c)
	return c:IsType(TYPE_ACCESS) and c:IsAbleToRemoveAsCost()
end
function c111310071.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310071.cfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c111310071.cfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c111310071.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c111310071.drop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
