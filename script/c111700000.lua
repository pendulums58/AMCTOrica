--천공전령 헤르메시아
local s,id=GetID()
function c111700000.initial_effect(c)
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_RELEASE)
	e1:SetCountLimit(1,111700000)
	e1:SetCondition(s.svcon)
	e1:SetTarget(c111700000.svtg)
	e1:SetOperation(c111700000.svop)
	c:RegisterEffect(e1)
	--m/s to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111700000,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,111700900)
	e2:SetTarget(c111700000.target)
	e2:SetOperation(c111700000.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_SANCTUARY_SKY}
function s.svcfilter(c,tp)
	return c:IsPreviousControler(tp) and c:GetPreviousRaceOnField()&RACE_FAIRY==RACE_FAIRY
end
function s.svcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.svcfilter,1,nil,tp)
end
function c111700000.svtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c111700000.svop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c111700000.thfilter(c)
	return c:IsType(TYPE_TRAP) and c:ListsCode(CARD_SANCTUARY_SKY) and c:IsAbleToHand()
end
function c111700000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111700000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111700000.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111700000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end