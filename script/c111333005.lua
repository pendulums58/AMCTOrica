--후부키류 - 날개 쉬기
function c111333005.initial_effect(c)
--매장
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111333005,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111333005)	
	e1:SetCost(c111333005.cost)
	e1:SetTarget(c111333005.target)
	e1:SetOperation(c111333005.operation)
	c:RegisterEffect(e1)		
--회복
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111333005,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)	
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)		
	e2:SetCountLimit(1,111333505)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c111333005.rectg)
	e2:SetOperation(c111333005.recop)
	c:RegisterEffect(e2)	
end
--매장
function c111333005.cfilter(c)
	return c:IsAbleToDeckAsCost() and (c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)) and c:IsSetCard(0x649)
end
function c111333005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111333005.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c111333005.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c111333005.tgfilter(c)
	return c:IsSetCard(0x1649) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c111333005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111333005.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c111333005.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c111333005.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--회복
function c111333005.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c111333005.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end