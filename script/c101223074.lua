--엄동설한 명령
function c101223074.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223074.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223074.tg)
	e1:SetOperation(c101223074.op)
	c:RegisterEffect(e1)		
end
function c101223074.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c101223074.fchk,tp,LOCATION_MZONE,0,nil)
	return Duel.GetCurrentChain()>=3-ct
end
function c101223074.fchk(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c101223074.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101223074.spfilter(chkc,e,tp))
		or (chkc:IsOnField()) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223074.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ct=ct+1 end	
		if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
			and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) then ct=ct+1 end
		if true then ct=ct+1 end
		if true then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223074.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		ops[off]=aux.Stringid(101223074,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(101223074,2)
		opval[off-1]=2
		off=off+1
	end	
	if true then
		ops[off]=aux.Stringid(101223074,3)
		opval[off-1]=3
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(101223074,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223074.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,g1:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
		local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		g:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,LOCATION_ONFIELD)	
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		local ch=Duel.GetCurrentChain()
		local mc=0
		for i=1,ch do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:GetHandlerPlayer()==tp then mc=mc+1 end
		end
		if mc>2 then
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,2,tp,0)	
		end	
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223074.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,g1:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
		local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		g:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,LOCATION_ONFIELD)			
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		local ch=Duel.GetCurrentChain()
		local mc=0
		for i=1,ch do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:GetHandlerPlayer()==tp then mc=mc+1 end
		end
		if mc>2 then
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,2,tp,0)	
		end	
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
end
function c101223074.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex2,g1=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if g1 and g1:GetCount()>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end		
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	if g and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local ch=Duel.GetCurrentChain()
		local mc=0
		for i=1,ch do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:GetHandlerPlayer()==tp then mc=mc+1 end
		end
		if mc>2 then
			Duel.Draw(tp,2,REASON_EFFECT)	
		end	
	end
	if bit.band(val,2)==2 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetOperation(c101223074.ccop)
		Duel.RegisterEffect(e3,tp)		
	end
end
function c101223074.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223074.ccop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		Duel.SetChainLimit(c101223074.chainlm)
	end
end
function c101223074.chainlm(e,rp,tp)
	return tp==rp
end
