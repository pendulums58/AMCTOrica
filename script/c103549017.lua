--마칭 파이어 에제키엘
function c103549017.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),4,2)
	c:EnableReviveLimit()
	--destroy deck & draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103549017,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,103549017)
	e1:SetCost(c103549017.drcost)
	e1:SetTarget(c103549017.distg)
	e1:SetOperation(c103549017.drop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103549017,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,103549917)
	e2:SetCost(c103549017.thcost)
	e2:SetTarget(c103549017.thtg)
	e2:SetOperation(c103549017.thop)
	c:RegisterEffect(e2)
end
c103549017.counter_add_list={0x1325}
function c103549017.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c103549017.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,4,tp,LOCATION_DECK)
end
function c103549017.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLocation(LOCATION_GRAVE)
end
function c103549017.drop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetDecktopGroup(tp,4)
	Duel.Destroy(dg,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c103549017.cfilter,nil)
	local t=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil,0x1019,1)
	if ct>0 then
		for i=1,ct do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local tc=t:Select(tp,1,1,nil):GetFirst()
			tc:AddCounter(0x1325,1)
		end
	end
end
function c103549017.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1325,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1325,1,REASON_COST)
end
function c103549017.filter(c)
	return c:IsSetCard(0xac6) and c:IsAbleToHand()
end
function c103549017.disfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c103549017.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c103549017.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103549017.filter,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingTarget(c103549017.disfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c103549017.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c103549017.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		if Duel.SendtoHand(sg,nil,REASON_EFFECT) then
		local dg=Duel.SelectMatchingCard(tp,c103549017.disfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
