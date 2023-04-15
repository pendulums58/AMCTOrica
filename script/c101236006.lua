--발할라즈 프리퍼레이션
function c101236006.initial_effect(c)
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101236006)
	e1:SetTarget(c101236006.target)
	e1:SetOperation(c101236006.activate)
	c:RegisterEffect(e1)
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CHEMICAL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101236906)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101236006.cmtg)
	e2:SetOperation(c101236006.cmop)
	c:RegisterEffect(e2)
end
function c101236006.thfilter(c)
	return c:IsCode(101236009) and c:IsAbleToHand()
end
function c101236006.thfilter1(c)
	return c:IsSetCard(0x659) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c101236006.scchk(c,sc)
	return c:IsCode(sc) and c:IsFaceup()
end
function c101236006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(c101236006.thfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c101236006.thfilter1,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c101236006.scchk,tp,LOCATION_SZONE,0,1,nil,101236009)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101236006.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101236006.thfilter,tp,LOCATION_DECK,0,1,nil)
	if Duel.IsExistingMatchingCard(c101236006.scchk,tp,LOCATION_SZONE,0,1,nil,101236009) then
		local eg=Duel.GetMatchingGroup(c101236006.thfilter1,tp,LOCATION_DECK,0,1,nil)
		g:Merge(eg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c101236006.cmfilter(c)
	return c:IsFaceup() and c:IsCode(101236009)
end
function c101236006.cmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101236006.cmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101236006.cmfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101236006.cmfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101236006.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x658) and c:IsType(TYPE_MONSTER)
end
function c101236006.cmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c101236006.cfilter,tp,LOCATION_MZONE,0,nil)
	yipi.SelectChemical(tp,tc)
	while ct>1 do
		if Duel.SelectYesNo(tp,aux.Stringid(101236006,0)) then
		yipi.SelectChemical(tp,tc)
		ct=ct-1
		else break end
	end
end