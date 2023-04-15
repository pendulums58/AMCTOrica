--시계탑 순찰방위대
function c101213322.initial_effect(c)
	c:SetSPSummonOnce(101213322)
	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x60a),2,2)
	c:EnableReviveLimit()
	--유옥의 시계탑 발동
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101213322,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(cyan.htgcost(1))
	e1:SetCondition(c101213322.thcon)
	e1:SetTarget(c101213322.thtg)
	e1:SetOperation(c101213322.thop)
	c:RegisterEffect(e1)
	--1드로
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101213322.condition)
	e2:SetTarget(c101213322.target)
	e2:SetOperation(c101213322.activate)
	c:RegisterEffect(e2)
end
function c101213322.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101213322.thfilter(c)
	return c:IsSetCard(0x60a) and c:IsAbleToHand()
end
function c101213322.ctfilter(c)
	return c:IsCode(CARD_CLOCKTOWER) and c:IsAbleToHand()
end
function c101213322.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213322.thfilter,tp,LOCATION_DECK,0,2,nil)
		and Duel.IsExistingMatchingCard(c101213322.ctfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101213322.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101213322.ctfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(tp,c101213322.thfilter,tp,LOCATION_DECK,0,1,1,g)
	if #g>0 and #g1>0 then
		g:Merge(g1)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101213322.condition(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c101213322.cfilter,1,nil,lg)
end
function c101213322.cfilter(c,lg)
	return lg:IsContains(c) and c:IsSetCard(0x60a) and (c:IsType(TYPE_SYNCHRO+TYPE_FUSION+TYPE_XYZ) or c:IsType(TYPE_PAIRING) or c:IsType(TYPE_ACCESS))
end
function c101213322.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101213322.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
