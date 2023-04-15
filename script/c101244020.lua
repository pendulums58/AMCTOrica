--결합하는 세계
function c101244020.initial_effect(c)
	--발동시 효과 처리
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101244020+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101244020.activate)
	c:RegisterEffect(e1)	
	--파괴 후 서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101244020,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101244020.destg)
	e2:SetOperation(c101244020.desop)
	c:RegisterEffect(e2)	
end
function c101244020.thfilter(c)
	if not c:IsAbleToHand() then return false end
	if c:IsSetCard(0xeff) then return true end
	if c:IsSetCard(0x60b) then return true end
	if c:IsSetCard(0x60f) then return true end
	if c:IsSetCard(0x611) then return true end
	if c:IsSetCard(0x612) then return true end
	if c:IsSetCard(0x61d) then return true end
	if c:IsSetCard(0x61e) then return true end
	if c:IsSetCard(0xeff) then return true end
	return false
end
function c101244020.smcheck(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c101244020.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101244020.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.IsExistingMatchingCard(c101244020.smcheck,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101244020,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101244020.thfilter1(c)
	return c:IsSetCard(0x606) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101244020.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c101244020.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101244020.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101244020.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end