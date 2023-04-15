--테스트용카드
function c101261999.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsSetCard,0x62b,Card.IsRace,RACE_FAIRY)
	c:RegisterEffect(e1)	
end
