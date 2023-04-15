--어드민즈 익스페디션
function c111310100.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111310100)
	e1:SetCondition(c111310100.condition)
	e1:SetTarget(c111310100.target)
	e1:SetOperation(c111310100.activate)
	c:RegisterEffect(e1)		
end
function c111310100.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_ACCESS)
end
function c111310100.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c111310100.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c111310100.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c111310100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310100.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c111310100.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c111310100.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if Duel.GetAdminCount(tp,1,nil)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(111310100,0)) then
			if Duel.RemoveAdmin(tp,1,0,1,1,REASON_EFFECT)~=0 then
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
				if g1:GetCount()>0 then Duel.SendtoGrave(g1,REASON_EFFECT) end
			end
		end
	end
end