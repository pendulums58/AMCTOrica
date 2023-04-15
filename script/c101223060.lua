--아이리의 명령
function c101223060.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223060.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223060.tg)
	e1:SetOperation(c101223060.op)
	c:RegisterEffect(e1)	
end
function c101223060.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223060.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223060.conchk(c)
	return c:IsType(TYPE_ACCESS)
end
function c101223060.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) and chkc:IsAttackAbove(1))
		or (chkc:IsLocation(LOCATION_MZONE) and c101223060.desfilter(chkc)) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(Card.IsAttackAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,1) then ct=ct+1 end
		if Duel.IsExistingTarget(c101223060.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223060.thfilter,tp,LOCATION_DECK,0,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,nil,RACE_CREATORGOD)
			and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(Card.IsAttackAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,1) then
		ops[off]=aux.Stringid(101223060,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(c101223060.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(101223060,2)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223060.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(101223060,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,nil,RACE_CREATORGOD)
			and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP) then
		ops[off]=aux.Stringid(101223060,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsAttackAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil,1)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223060.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsAttackAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil,1)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223060.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end	
end
function c101223060.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)	
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	g1:Sub(g)
	if g1:GetCount()>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		local tc=g1:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=g1:GetNext()
		end
	end
	if g and g:GetCount()>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.Destroy(g,REASON_EFFECT)
	end	
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g3=Duel.SelectMatchingCard(tp,c101223060.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g3:GetCount()>0 then
			Duel.SendtoHand(g3,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g3)
		end
	end
	if bit.band(val,2)==2 then
		if Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,nil,RACE_CREATORGOD) then
			local g4=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
			if g4:GetCount()>0 then
				Duel.Destroy(g4,REASON_EFFECT)
			end
		end
	end
end

function c101223060.desfilter(c)
	return not (c:IsType(TYPE_ACCESS) and c:GetAdmin()~=nil)
end
function c101223060.thfilter(c)
	return c:IsSetCard(0x606) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end