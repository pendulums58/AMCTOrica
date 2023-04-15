--고행서사 명령
function c101223051.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223051.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223051.tg)
	e1:SetOperation(c101223051.op)
	c:RegisterEffect(e1)
end
function c101223051.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223051.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223051.conchk(c)
	return c:IsType(TYPE_ACCESS) and c:GetBaseAttack()>=4000
end
function c101223051.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and c101223051.dfilter(chkc))
		or (chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101223051.thfilter(chkc)) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223051.dfilter,tp,0,LOCATION_ONFIELD,1,nil) then ct=ct+1 end
		if Duel.IsExistingTarget(c101223051.thfilter,tp,LOCATION_GRAVE,0,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223051.adfilter,tp,LOCATION_MZONE,0,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223051.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223051.dfilter,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(101223051,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(c101223051.thfilter,tp,LOCATION_GRAVE,0,1,nil) then
		ops[off]=aux.Stringid(101223051,2)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223051.adfilter,tp,LOCATION_MZONE,0,1,nil) then
		ops[off]=aux.Stringid(101223051,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223051.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(101223051,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_NEGATE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223051.dfilter,tp,0,LOCATION_ONFIELD,1,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223051.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
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
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_NEGATE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223051.dfilter,tp,0,LOCATION_ONFIELD,1,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223051.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
end
function c101223051.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex1,g=Duel.GetOperationInfo(0,CATEGORY_DISABLE)
	local ex2,g1=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	if g and g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
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
			tc=g:GetNext()
		end
	end
	if g1 and g1:GetCount()>0 then
		if g1:GetFirst():IsRelateToEffect(e) then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
		end
	end
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		Duel.RemoveAdmin(tp,1,0,1,1,REASON_EFFECT)
	end
	if bit.band(val,2)==2 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e2:SetValue(c101223051.atkval)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)	
	end
end
function c101223051.atkval(e,c)
	return c:GetBaseAttack()
end
function c101223051.dfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c101223051.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c101223051.adfilter(c)
	return c:IsType(TYPE_ACCESS) and c:GetAdmin()~=nil
end
function c101223051.atkfilter(c)
	return c:GetAttack()~=c:GetBaseAttack()
end