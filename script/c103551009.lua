--시라유키식 환성창론
function c103551009.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,103551009+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c103551009.target)
	e1:SetOperation(c103551009.activate)
	c:RegisterEffect(e1)
	--묘지 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c103551009.thcost)
	e2:SetCondition(c103551009.thcon)
	e2:SetTarget(c103551009.target1)
	e2:SetOperation(c103551009.activate1)
	c:RegisterEffect(e2)	
end
function c103551009.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x64b)
end
function c103551009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c103551009.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)*3
		if ct==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c103551009.chk2(c)
	return c:IsSetCard(0x64b) and c:IsType(TYPE_PAIRING)
end
function c103551009.thfilter(c)
	local tp=c:GetControler()
	return c:IsType(TYPE_EQUIP) or (Duel.IsExistingMatchingCard(c103551009.chk2,tp,LOCATION_MZONE,0,1,nil)
		and c:IsSetCard(0x64b))
end
function c103551009.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c103551009.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)*3
	if ct==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,ct)
	local g=Duel.GetDecktopGroup(p,ct)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(p,c103551009.thfilter,1,1,nil)
		if sg:GetCount()>0 and sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(p)
	end
end
function c103551009.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c103551009.thchk,1,nil,tp)
end
function c103551009.thchk(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_PAIRING) and c:IsPreviousControler(tp)
end
function c103551009.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c103551009.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c103551009.costfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then g:AddCard(e:GetHandler()) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c103551009.costfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function c103551009.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c103551009.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c103551009.filter1(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c103551009.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c103551009.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c103551009.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end