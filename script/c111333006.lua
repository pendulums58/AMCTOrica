--후부키류 - 벚나무 베기
function c111333006.initial_effect(c)
--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111333006)	
	e1:SetCondition(c111333006.condition)	
	e1:SetTarget(c111333006.target)
	e1:SetOperation(c111333006.activate)
	c:RegisterEffect(e1)	
--드로우	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111333006,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,111333506)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c111333006.drcon)
	e2:SetTarget(c111333006.drtg)
	e2:SetOperation(c111333006.drop)
	c:RegisterEffect(e2)
end
--서치
function c111333006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 
end
function c111333006.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x649) and c:IsType(TYPE_MONSTER)
end
function c111333006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111333006.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c111333006.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c111333006.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--드로우
function c111333006.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 and aux.exccon(e) 
end
function c111333006.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c111333006.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end