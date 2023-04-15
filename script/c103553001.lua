--카미가와 발도검
function c103553001.initial_effect(c)
	aux.AddCodeList(c,103553000)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103553001,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c103553001.rmtg)
	e1:SetOperation(c103553001.rmop)
	c:RegisterEffect(e1)
	--앵화난무
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c103553001.tdcost)
	e2:SetCondition(cyan.IsUnlockState)
	e2:SetTarget(c103553001.thtg)
	e2:SetOperation(c103553001.thop)
	c:RegisterEffect(e2)
end
function c103553001.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if Duel.IsExistingMatchingCard(c103553001.chk,tp,LOCATION_MZONE,0,1,nil) then
			return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToDeck() and chkc:IsFacedown()
		else
			return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFacedown() and chkc:IsAbleToHand() 
		end
	end
	if chk==0 then 
		if Duel.IsExistingMatchingCard(c103553001.chk,tp,LOCATION_MZONE,0,1,nil) then
			return Duel.IsExistingTarget(c103553001.tgchk,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp,0)  
		else
			return Duel.IsExistingTarget(c103553001.tgchk,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp,1)  
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if Duel.IsExistingMatchingCard(c103553001.chk,tp,LOCATION_MZONE,0,1,nil) then
		local g=Duel.SelectTarget(tp,c103553001.tgchk,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),tp,0)
		g:KeepAlive()
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	else
		local g=Duel.SelectTarget(tp,c103553001.tgchk,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),tp,1)
		g:KeepAlive()
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end
	if cyan.IsUnlockState(e,tp) then
		Duel.SetChainLimit(c103553001.limit(g))
	end
end
function c103553001.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end

function c103553001.tgchk(c,tp,val)
	if val==0 then
		return c:IsFacedown() and c:IsAbleToDeck()
	else
		return c:IsFacedown() and c:IsAbleToHand()
	end
end
function c103553001.chk(c)
	return c:IsFaceup() and c:IsCode(103553000)
end
function c103553001.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.IsExistingMatchingCard(c103553001.chk,tp,LOCATION_MZONE,0,1,nil) then
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c103553001.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(103553001)~=0
end
function c103553001.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c103553001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103553001.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c103553001.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c103553001.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		cyan.AddFuriosoStack(tp,1)
	end
end
function c103553001.thfilter(c)
	return c:IsCode(103553000) and c:IsAbleToHand()
end
function c103553001.tdfilter(c)
	return aux.IsCodeListed(c,103553000) and c:IsAbleToDeckAsCost() and not c:IsCode(103553001)
end
function c103553001.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c103553001.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>=1 and e:GetHandler():IsAbleToDeckAsCost() end
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,1)
	sg1:AddCard(e:GetHandler())
	Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_COST)
end