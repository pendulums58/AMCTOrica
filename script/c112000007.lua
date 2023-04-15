--스트래터스의 꿈
function c112000007.initial_effect(c)
	--묘지로 보낸다
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE,CATEGORY_DECKDES)	
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,112000007,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c112000007.activate)
	c:RegisterEffect(e1)	
	--카드군
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(aux.TargetBoolFunction(aux.TRUE))
	e2:SetValue(0x643)
	c:RegisterEffect(e2)	
end
function c112000007.filter(c,e,tp)
	return c:IsSetCard(0x663) and c:IsMonster()  and c:IsAbleToGrave()
end
function c112000007.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c112000007.filter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(112000007,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end