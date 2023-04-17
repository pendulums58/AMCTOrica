--마른 하늘에 날벼락
local s,id=GetID()
function s.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.con)
	e1:SetCountLimit(1)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsRace,RACE_THUNDER)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase==PHASE_STANDBY
end