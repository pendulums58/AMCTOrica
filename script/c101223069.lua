--혜성의 명령
function c101223069.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223069.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223069.tg)
	e1:SetOperation(c101223069.op)
	c:RegisterEffect(e1)		
end
function c101223069.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223069.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223069.conchk(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAttribute(ATTRIBUTE_WIND)
end
function c101223069.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) and chkc:IsLevelAbove(1))
		or (chkc:IsLocation(LOCATION_ONFIELD)) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(Card.IsLevelAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,1) then ct=ct+1 end
		if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223069.thfilter,tp,LOCATION_DECK,0,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223069.rmfilter,tp,LOCATION_MZONE,0,1,nil) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(Card.IsLevelAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,1) then
		ops[off]=aux.Stringid(101223069,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(101223069,2)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223069.thfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(101223069,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223069.rmfilter,tp,LOCATION_MZONE,0,1,nil) then
		ops[off]=aux.Stringid(101223069,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsLevelAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,3,nil,1)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsLevelAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,3,nil,1)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
end
function c101223069.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)	
	local g1=Group.CreateGroup()
	g1:Merge(g2)
	if g and g1 and g:GetCount()>0 then g1:Sub(g) end
	if g1 and g1:GetCount()>0 then
		local tc=g1:GetFirst()
		while tc do
			if tc:IsFaceup() and tc:IsRelateToEffect(e) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(tc:GetLevel()*2)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
			end
			tc=g1:GetNext()	
		end
	end
	if g and g:GetCount()>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end	
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local g4=Duel.SelectMatchingCard(tp,c101223069.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g4:GetCount()>0 then
			Duel.SendtoHand(g4,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g4)
		end
	end
	if bit.band(val,2)==2 then
		local g3=Duel.SelectMatchingCard(tp,c101223069.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g3:GetCount()>0 then
			local rc=g3:GetFirst()
			local op=0
			if rc:IsAbleToRemove() then op=op+1 end
			if rc:IsAbleToGrave() then op=op+2 end
			if op==3 then
				op=Duel.SelectOption(tp,aux.Stringid(101223069,5),aux.Stringid(101223069,6))+1
			end
			if op==1 and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetRange(LOCATION_REMOVED)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e1:SetOperation(c101223069.operation)
				e1:SetReset(RESET_PHASE+PHASE_END)
				rc:RegisterEffect(e1)
			end
			if op==2 and Duel.SendtoGrave(rc,REASON_EFFECT)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetRange(LOCATION_GRAVE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e1:SetOperation(c101223069.operation)
				e1:SetReset(RESET_PHASE+PHASE_END)
				rc:RegisterEffect(e1)			
			end
		end
	end
end
function c101223069.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c101223069.rmfilter(c)
	return c:IsAbleToGrave() or c:IsAbleToRemove()
end
function c101223069.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
