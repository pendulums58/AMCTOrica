--프라나의 명령
function c101223100.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cyan.dhcost(1))
	e1:SetCondition(c101223100.con)
	e1:SetTarget(c101223100.tg)
	e1:SetOperation(c101223100.op)
	c:RegisterEffect(e1)
end
function c101223100.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)==1
		and Duel.IsExistingMatchingCard(c101223100.chk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223100.chk(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsLevel(4)
end
function c101223100.thfilter(c,code)
	return c:IsAbleToHand() and aux.IsCodeListed(c,code) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101223100.tgfilter(c,tp)
	return Duel.IsExistingMatchingCard(c101223100.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
		and Duel.IsExistingMatchingCard(c101223100.thfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c101223100.desfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,c,c:GetCode())
end
function c101223100.gfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode()) and c:IsAbleToGrave()
end
function c101223100.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
		(chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
				and Duel.IsExistingMatchingCard(c101223100.thfilter,tp,LOCATION_DECK,0,1,nil,chkc:GetCode())
				and Duel.IsExistingMatchingCard(c101223100.thfilter,tp,LOCATION_GRAVE,0,1,nil,chkc:GetCode()))
		or
		(chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup()
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,chkc,chkc:GetCode()))
	end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223100.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) then ct=ct+1 end	
		if Duel.IsExistingTarget(c101223100.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp) then ct=ct+1 end
		if true then ct=ct+1 end
		if 
			Duel.IsExistingMatchingCard(c101223100.gfilter,tp,LOCATION_DECK,0,1,nil,tp)
		then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223100.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) then
		ops[off]=aux.Stringid(101223100,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(c101223100.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp) then
		ops[off]=aux.Stringid(101223100,2)
		opval[off-1]=2
		off=off+1
	end	
	if true then
		ops[off]=aux.Stringid(101223100,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223100.gfilter,tp,LOCATION_DECK,0,1,nil,tp) then
		ops[off]=aux.Stringid(101223100,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223100.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,0,LOCATION_DECK)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223100.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,LOCATION_ONFIELD)	
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)	
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223100.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,0,LOCATION_DECK)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223100.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,LOCATION_ONFIELD)			
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)	
	end	
end
function c101223100.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex2,g1=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg and tg:GetCount()>0 and tg:GetFirst():IsRelateToEffect(e) then
		if g1 and g1:GetCount()>0 then
			tg:Sub(g1)
		end
		local code=tg:GetFirst():GetCode()
		local thg=Duel.SelectMatchingCard(tp,c101223100.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
		local thg1=Duel.SelectMatchingCard(tp,c101223100.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,code)
		thg:Merge(thg1)
		if thg:GetCount()>0 then
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(thg,1-tp)
		end
	
	end
	if g1 and g1:GetCount()>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		if g1:GetCount()>0 then
			Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		end
	end		
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		Duel.RegisterEffect(e2,tp)
	end
	if bit.band(val,2)==2 then
		local g=Duel.SelectMatchingCard(tp,c101223100.gfilter,tp,LOCATION_DECK,0,1,2,nil,tp)	
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end