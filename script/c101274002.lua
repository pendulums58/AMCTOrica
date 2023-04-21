--송별의 문곡 글로리아
local s,id=GetID()
function s.initial_effect(c)
	--튜너 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsSetCard,SETCARD_MORSTAR,Card.IsType,TYPE_TUNER)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	cyan.JustSearch(e2,LOCATION_DECK,Card.IsSetCard,SETCARD_MORSTAR,Card.IsType,TYPE_TUNER)
	c:RegisterEffect(e2)
	--묘지 특소
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+100)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.gthtg)
	e3:SetOperation(s.gthop)
	c:RegisterEffect(e3)
end
function s.gthfilter(c)
	return c:IsSetCard(SETCARD_MORSTAR) and c:IsMonster() and c:IsAbleToHand()
end
function s.gthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.gthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.gthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.gthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
end