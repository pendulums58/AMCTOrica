--대충테스트카드
function c101262999.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsLevelBelow,1422)
	c:RegisterEffect(e1)	
end