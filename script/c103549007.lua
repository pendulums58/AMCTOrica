--마칭 파이어 번 더 팔레스
function c103549007.initial_effect(c)
	--code
	aux.EnableChangeCode(c,82705573,LOCATION_SZONE+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy+search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103549007,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,103549007)
	e2:SetTarget(c103549007.target)
	e2:SetOperation(c103549007.operation)
	c:RegisterEffect(e2)
	--distroy
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103549007,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,103549907)
	e3:SetCost(c103549007.thcost)
	e3:SetTarget(c103549007.thtg)
	e3:SetOperation(c103549007.thop)
	c:RegisterEffect(e3)
end
c103549007.counter_add_list={0x1325}
function c103549007.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c103549007.filter2(c)
	return c:IsSetCard(0xac6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c103549007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103549007.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c103549007.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c103549007.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c103549007.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c103549007.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c103549007.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1325,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1325,2,REASON_COST)
end
function c103549007.desfilter(c,ft)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c103549007.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c103549007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingTarget(c103549007.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ft)
		and Duel.IsExistingTarget(c103549007.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c103549007.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c103549007.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
end
function c103549007.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if tc1:IsRelateToEffect(e) and Duel.Destroy(tc1,REASON_EFFECT)>0 and tc2:IsRelateToEffect(e) then
		Duel.SendtoHand(tc2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
