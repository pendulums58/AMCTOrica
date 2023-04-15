--안개관문 명령
function c101223052.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223052.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223052.tg)
	e1:SetOperation(c101223052.op)
	c:RegisterEffect(e1)	
end
function c101223052.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223052.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223052.conchk(c)
	return c:IsType(TYPE_TOKEN) and c:IsRace(RACE_FIEND)
end
function c101223052.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c101223052.thfilter(chkc,tp))
		or (chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101223052.thfilter1(chkc)) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223052.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) then ct=ct+1 end
		if Duel.IsExistingTarget(c101223052.thfilter1,tp,LOCATION_GRAVE,0,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223052.relfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(c101223052.relfilter,tp,0,LOCATION_MZONE,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223052.deffilter,tp,0,LOCATION_MZONE,1,nil) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223052.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) then
		ops[off]=aux.Stringid(101223052,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(c101223052.thfilter1,tp,LOCATION_GRAVE,0,1,nil) then
		ops[off]=aux.Stringid(101223052,2)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223052.relfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101223052.relfilter,tp,0,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(101223052,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223052.deffilter,tp,0,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(101223052,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223052.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223052.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223052.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223052.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
end
function c101223052.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	local g1=Group.CreateGroup()
	g1:Merge(g2)
	if g then g1:Sub(g) end
	if g1 and g1:GetCount()>0 then
		local tc=g1:GetFirst()
		local te=tc:GetActivateEffect()
		local b2=te:IsActivatable(tp,true,true)
		if te:IsActivatable(tp,true,true) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end	
	end
	if g and g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local r=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_MZONE,0,1,1,nil)
		local r1=Duel.SelectMatchingCard(1-tp,Card.IsReleasableByEffect,1-tp,LOCATION_MZONE,0,1,1,nil)
		if r:GetCount()>0 and r1:GetCount()>0 then
			r:Merge(r1)
			Duel.Release(r,REASON_EFFECT)
		end
	end
	if bit.band(val,2)==2 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetValue(0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)	
	end
end
function c101223052.atkval(e,c)
	return c:GetBaseAttack()
end
function c101223052.thfilter(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c101223052.thfilter1(c)
	return c:IsLevel(7) and c:IsAbleToHand()
end
function c101223052.relfilter(c)
	return c:IsReleasableByEffect()
end
function c101223052.deffilter(c)
	return not c:GetBaseDefense()==0
end