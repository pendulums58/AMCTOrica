--먹구름의 명령
function c101223067.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223067.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223067.tg)
	e1:SetOperation(c101223067.op)
	c:RegisterEffect(e1)	
end
function c101223067.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223067.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223067.conchk(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAttribute(ATTRIBUTE_DARK)
end
function c101223067.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) and c101223067.negfilter(chkc))
		or (chkc:IsDisabled() and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup()) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223067.negfilter,tp,LOCATION_MZONE,0,1,nil) then ct=ct+1 end
		if Duel.IsExistingTarget(Card.IsDisabled,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then ct=ct+1 end
		if true then ct=ct+1 end
		if Duel.IsPlayerCanDraw(tp,2) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223067.negfilter,tp,LOCATION_MZONE,0,1,nil) then
		ops[off]=aux.Stringid(101223067,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(Card.IsDisabled,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(101223067,2)
		opval[off-1]=2
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(101223067,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsPlayerCanDraw(tp,2) then
		ops[off]=aux.Stringid(101223067,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_DISABLE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223067.negfilter,tp,LOCATION_MZONE,0,1,1,nil)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,Card.IsDisabled,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,2,0,0)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_DISABLE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223067.negfilter,tp,LOCATION_MZONE,0,1,1,nil)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,Card.IsDisabled,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,2,0,0)
	end	
end
function c101223067.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local g1=Group.CreateGroup()
	g1:Merge(g2)
	if g then g1:Sub(g) end
	if g1:GetCount()>0 then
		local tc=g1:GetFirst()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() and not tc:IsImmuneToEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
	if g and g:GetCount()>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.Destroy(g,REASON_EFFECT)
	end	
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		if c:IsLocation(LOCATION_SZONE) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e4:SetTarget(c101223067.distg)
			e4:SetReset(RESET_PHASE+PHASE_END)
			e4:SetLabel(c:GetSequence())
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_CHAIN_SOLVING)
			e5:SetOperation(c101223067.disop)
			e5:SetReset(RESET_PHASE+PHASE_END)
			e5:SetLabel(c:GetSequence())
			Duel.RegisterEffect(e5,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD)
			e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e6:SetTarget(c101223067.distg)
			e6:SetReset(RESET_PHASE+PHASE_END)
			e6:SetLabel(c:GetSequence())
			Duel.RegisterEffect(e6,tp)
		end
	end
	if bit.band(val,2)==2 then
		if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetTargetRange(1,0)
			e2:SetValue(1)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c101223067.negfilter(c)
	return not c:IsDisabled()
end
function c101223067.distg(e,c)
	local seq=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.GetColumn(c,tp)==seq
end
function c101223067.disop(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetLabel()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE~=0 and seq<=4 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then
		Duel.NegateEffect(ev)
	end
end