--신살마녀 엑스큐니아
function c101226003.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101226003,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101226003)
	e1:SetTarget(c101226003.target)
	e1:SetOperation(c101226003.operation)
	c:RegisterEffect(e1)
	--패 교환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101226003,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCost(cyan.htgcost(1))
	e3:SetCondition(c101226003.spcon1)
	e3:SetTarget(c101226003.sptg)
	e3:SetOperation(c101226003.spop)
	c:RegisterEffect(e3)	
end
function c101226003.filter(c)
	return c:IsSetCard(0x612) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101226003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101226003.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101226003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101226003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101226003.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_ACCESS and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c101226003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetChainLimit(c101226003.chainlm)
end
function c101226003.chainlm(e,rp,tp)
	return tp==rp
end
function c101226003.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
