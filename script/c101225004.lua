--흑백의 수호자 시그너스
function c101225004.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()	
	--회수
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101225004,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101225004)
	e1:SetCost(aux.bfgcost)	
	e1:SetCondition(c101225004.condition)
	e1:SetTarget(c101225004.target)
	e1:SetOperation(c101225004.operation)
	c:RegisterEffect(e1)
end
function c101225004.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:GetHandler():IsCode(31677606) 
	and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c101225004.filter(c)
	return c:IsLocation(LOCATION_GRAVE) 
	and c:IsSetCard(0x60b) 
	and c:IsType(TYPE_MONSTER)
	and c:IsAbleToDeck()
end
function c101225004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101225004.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c101225004.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101225004.filter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end