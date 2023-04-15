--폰더링 얼론 치터
function c101223163.initial_effect(c)
	--론냐!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101223163)
	e1:SetCost(c101223163.thcost)
	e1:SetTarget(c101223163.thtg)
	e1:SetOperation(c101223163.thop)
	c:RegisterEffect(e1)
end
function c101223163.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=re:GetHandler()
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	g:AddCard(tc)
	g:AddCard(c)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223163.chk,tp,LOCATION_HAND,0,1,c,g)
		or Duel.IsExistingMatchingCard(c101223163.chk1,tp,LOCATION_HAND,0,1,c,g) end
	local g1=Group.CreateGroup()
	if tc:GetLevel()==c:GetLevel() then 
		g1=Duel.SelectMatchingCard(tp,c101223163.chk1,tp,LOCATION_HAND,0,1,1,c,g)
	else
		g1=Duel.SelectMatchingCard(tp,c101223163.chk,tp,LOCATION_HAND,0,1,1,c,g)
	end
	g1:AddCard(c)
	Duel.ConfirmCards(g1,1-tp)
end
function c101223163.chk(c,g)
	local g1=Group.CreateGroup()
	g1:Merge(g)
	g1:AddCard(c)
	local mx=g1:GetMaxGroup(Card.GetLevel)
	local mxc=mx:GetFirst()
	return g1:IsExists(Card.IsLevel,1,nil,mxc:GetLevel()-1)
		and g1:IsExists(Card.IsLevel,1,nil,mxc:GetLevel()-2)
end
function c101223163.chk1(c,g)
	if g:GetClassCount(Card.GetLevel)~=1 then return false end
	local lv=g:GetFirst():GetLevel()
	return c:IsLevel(lv)
end
function c101223163.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=re:GetHandler()
	if chk==0 then return tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c101223163.thfilter,tp,LOCATION_DECK,0,1,nil,tc) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c101223163.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c101223163.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
function c101223163.thfilter(c,tc)
	local chk=0
	if c:IsAttribute(tc:GetAttribute()) then chk=chk+1 end
	if c:IsRace(tc:GetRace()) then chk=chk+1 end
	if c:IsLevel(tc:GetLevel()) then chk=chk+1 end
	if c:IsAttack(tc:GetAttack()) then chk=chk+1 end
	if c:IsDefense(tc:GetDefense()) then chk=chk+1 end
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and chk>2
end