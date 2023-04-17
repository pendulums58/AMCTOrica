--머신 러닝
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	cyan.JustSearch(e1,LOCATION_DECK,s.thfilter,1)	
	c:RegisterEffect(e1)
end
function s.thfilter(c,ct)
	local tp=c:GetControler()
	return c:IsAbleToHand() and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(s.thchk,tp,LOCATION_MZONE,0,1,nil,c)
end
function s.thchk(c,tc)
	return c:IsFaceup() and c:GetAttack()>tc:GetAttack()
end