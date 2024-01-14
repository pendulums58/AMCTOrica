--무덤에서의 조경
local s,id=GetID()
function s.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsRace,RACE_PLANT,Card.IsLevelBelow,4)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,Duel.GetTurnCount()) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,Duel.GetTurnCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.cfilter(c)
	return c:GetTurnID()==id and c:IsAbleToRemoveAsCost()
end
