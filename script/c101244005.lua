--리턴 프롬 어나더월드
function c101244005.initial_effect(c)
	--회수 혹은 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101244005)
	e1:SetTarget(c101244005.target)
	e1:SetOperation(c101244005.activate)
	c:RegisterEffect(e1)	
	--코스트가 된 카드 강탈
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101244005,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c101244005.thtg)
	e2:SetOperation(c101244005.thop)
	c:RegisterEffect(e2)	
end
function c101244005.filter(c)
	return c:IsSetCard(0x61e) and c:IsAbleToHand()
end
function c101244005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_FUSION) then loc=loc+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c101244005.filter,tp,loc,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c101244005.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_GRAVE
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_FUSION) then loc=loc+LOCATION_DECK end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101244005.filter,tp,loc,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101244005.thfilter(c)
	return c:IsReason(REASON_COST) and c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_HAND)
end
function c101244005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101244005.thfilter,1,nil) and ep==1-tp end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c101244005.thop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=eg:Filter(c101244005.thfilter,nil)
	if g:GetCount()>0 then 
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end