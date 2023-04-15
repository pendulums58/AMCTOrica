--유즈키의 명령
function c101223061.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223061.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223061.tg)
	e1:SetOperation(c101223061.op)
	c:RegisterEffect(e1)	
end
function c101223061.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223061.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223061.conchk(c)
	return c:IsType(TYPE_LINK)
end
function c101223061.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) and c101223061.spfilter(chkc,e,tp))
		or (chkc:IsLocation(LOCATION_MZONE) and chkc:IsLinkState()) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223061.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) then ct=ct+1 end
		if Duel.IsExistingTarget(Card.IsLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then ct=ct+1 end
		local lgc=Duel.GetMatchingGroupCount(c101223061.drfilter,tp,LOCATION_MZONE,0,nil)
		if lgc>0 and Duel.IsPlayerCanDraw(tp,lgc) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223061.lfilter,tp,LOCATION_EXTRA,0,1,nil) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223061.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(101223061,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(Card.IsLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(101223061,2)
		opval[off-1]=2
		off=off+1
	end
	local lgc=Duel.GetMatchingGroupCount(c101223061.drfilter,tp,LOCATION_MZONE,0,nil)
	if lgc>0 and Duel.IsPlayerCanDraw(tp,lgc) then
		ops[off]=aux.Stringid(101223061,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223061.lfilter,tp,LOCATION_EXTRA,0,1,nil) then
		ops[off]=aux.Stringid(101223061,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223061.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,Card.IsLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,LOCATION_MZONE)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		local lgc=Duel.GetMatchingGroupCount(c101223061.drfilter,tp,LOCATION_MZONE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,lgc,tp,0)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223061.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,Card.IsLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,LOCATION_MZONE)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		local lgc=Duel.GetMatchingGroupCount(c101223061.drfilter,tp,LOCATION_MZONE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,lgc,tp,0)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end	
end
function c101223061.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)	
	local g1=Group.CreateGroup()
	g1:Merge(g2)
	if g and g1 and g:GetCount()>0 then g1:Sub(g) end
	if g1 and g1:GetCount()>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		local tc=g1:GetFirst()
		local gg=Duel.SelectMatchingCard(tp,c101223061.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc)
		if gg:GetCount()>0 then
			local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
			Duel.SpecialSummon(gg,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
	if g and g:GetCount()>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end	
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local lgc=Duel.GetMatchingGroupCount(c101223061.drfilter,tp,LOCATION_MZONE,0,nil)
		if lgc>0 then Duel.Draw(tp,lgc,REASON_EFFECT) end
	end
	if bit.band(val,2)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101223061.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end
	end
end
function c101223061.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(c101223061.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,c)
end
function c101223061.spfilter1(c,e,tp,tc)
	local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsType(TYPE_MONSTER)
end
function c101223061.drfilter(c)
	return c:GetMutualLinkedGroupCount()>0
end
function c101223061.lfilter(c)
	return c:IsLinkSummonable(nil)
end