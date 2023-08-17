--네거티미드 모다로지
local s,id=GetID()
function s.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(cyan.selfdiscost)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsSetCard,SETCARD_NEGATIMID,Card.IsType,TYPE_MONSTER)
	c:RegisterEffect(e1)
	--회수
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end