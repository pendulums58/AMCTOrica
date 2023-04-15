--프라임 코드 액세스
--Scripted by Cyan
function c101223003.initial_effect(c)
	--프라임 코드 액세스
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101223003)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c101223003.target)
	e1:SetOperation(c101223003.activate)
	c:RegisterEffect(e1)
	--묘지 발동
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,101223003)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c101223003.target1)
	e2:SetOperation(c101223003.activate1)
	c:RegisterEffect(e2)	
end
function c101223003.tgfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c:GetCode())
	return g:GetCount()==3 and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c101223003.tgfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,c:GetCode())
end
function c101223003.tgfilter1(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c.primecode_name==code[0] and c:IsSetCard(0x618)
end
function c101223003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223003.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c101223003.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101223003.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetMZoneCount(tp,tc)<=0 then return end
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc1=Duel.SelectMatchingCard(tp,c101223003.tgfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())		
		if tc1 and Duel.SpecialSummon(tc1,0,tp,tp,true,false,POS_FACEUP)>0 then
			tc1:GetFirst():CompleteProcedure()
		end	
	end
end
function c101223003.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c101223003.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,2,c,c:GetCode())
end
function c101223003.filter1(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsCode(code)
end
function c101223003.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) and c101223003.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c101223003.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101223003.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	local g1=Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_MZONE+LOCATION_GRAVE,0,2,2,g:GetFirst(),g:GetFirst():GetCode())
	g:Merge(g1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101223003.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg1 or tg1:FilterCount(Card.IsRelateToEffect,nil,e)~=3 or not c:IsLocation(LOCATION_GRAVE) then return end
	local tg=Group.CreateGroup()
	tg:Merge(tg1)
	tg:AddCard(e:GetHandler())
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==4 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end