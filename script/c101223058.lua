--엑소스피어의 명령
function c101223058.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223058.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223058.tg)
	e1:SetOperation(c101223058.op)
	c:RegisterEffect(e1)		
end
function c101223058.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223058.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223058.conchk(c)
	return c:IsType(TYPE_SYNCHRO)
end
function c101223058.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101223058.spfilter(chkc,e,tp))
		or (chkc~=e:GetHandler() and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsType(TYPE_SPELL+TYPE_TRAP)) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223058.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ct=ct+1 end
		if Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223058.tgfilter,tp,LOCATION_DECK,0,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223058.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0	then
		ops[off]=aux.Stringid(101223058,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP) then
		ops[off]=aux.Stringid(101223058,2)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223058.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(101223058,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,niil) then
		ops[off]=aux.Stringid(101223058,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223058.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223058.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end	
end
function c101223058.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g1=Group.CreateGroup()
	g1:Merge(g2)
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	if g and g1 and g:GetCount()>0 then g1:Sub(g) end
	if g1 and g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
	if g and g:GetCount()>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.Destroy(g,REASON_EFFECT)
	end	
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local g3=Duel.SelectMatchingCard(tp,c101223058.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g3:GetCount()>0 then
			Duel.SendtoGrave(g3,REASON_EFFECT)
		end
	end
	if bit.band(val,2)==2 then
		local g4=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
		if g4:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g4:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
		end
	end
end

function c101223058.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223058.tgfilter(c)
	return c:IsLevel(1) and c:IsAbleToGrave()
end