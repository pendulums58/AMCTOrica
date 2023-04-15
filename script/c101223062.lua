--슈바르츠의 명령
function c101223062.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223062.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223062.tg)
	e1:SetOperation(c101223062.op)
	c:RegisterEffect(e1)	
end
function c101223062.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223062.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223062.conchk(c)
	return c:IsType(TYPE_PAIRING)
end
function c101223062.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) and c101223062.prfilter(chkc,tp))
		or (chkc:IsLocation(LOCATION_ONFIELD)) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223062.prfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) then ct=ct+1 end
		if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
			and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then ct=ct+1 end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(c101223062.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then ct=ct+1 end
		if Duel.IsPlayerCanDraw(tp,2) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223062.prfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) then
		ops[off]=aux.Stringid(101223062,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(101223062,2)
		opval[off-1]=2
		off=off+1
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c101223062.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(101223062,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsPlayerCanDraw(tp,2) then
		ops[off]=aux.Stringid(101223062,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223062.prfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,LOCATION_MZONE)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,2,0,0)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223062.prfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
		local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,LOCATION_MZONE)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,2,0,0)
	end	
end
function c101223062.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)	
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local g1=Group.CreateGroup()
	if g2 then g1:Merge(g2) end
	if g and g1 then g1:Sub(g) end
	if g1:GetCount()>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		local tc=g1:GetFirst()
		local gg=Duel.SelectMatchingCard(tp,c101223062.prfilter1,tp,LOCATION_MZONE,0,1,1,nil,tc)
		if gg:GetCount()>0 then
			local tc1=gg:GetFirst()
			tc1:SetPair(tc)
		end
	end
	if g and g:GetCount()>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.Destroy(g,REASON_EFFECT)
	end	
	local val=e:GetLabel()
	if bit.band(val,1)==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g3=Duel.SelectMatchingCard(tp,c101223062.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g3:GetCount()>0 then
			Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if bit.band(val,2)==2 then
		Duel.Draw(tp,2,REASON_EFFECT)
		if not Duel.IsExistingMatchingCard(Card.GetPairCount,tp,LOCATION_MZONE,0,1,nil) then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c101223062.prfilter(c,tp)
	return Duel.IsExistingMatchingCard(c101223062.prfilter1,tp,LOCATION_MZONE,0,1,nil,c) and c:IsFaceup()
end
function c101223062.prfilter1(c,tc)
	return not c:GetPair():IsContains(tc) and c:IsType(TYPE_PAIRING)
end
function c101223062.spfilter(c,e,tp)
	return c:IsType(TYPE_PAIRING) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101223062.pchk(c)
	return c:GetPairCount()>0
end