--여명의 명령
function c101223066.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223066.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223066.tg)
	e1:SetOperation(c101223066.op)
	c:RegisterEffect(e1)		
end
function c101223066.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223066.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223066.conchk(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c101223066.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c101223066.thfilter(chkc,tp))
		or (chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101223066.spfilter(chkc,e,tp)) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223066.thfilter,tp,0,LOCATION_GRAVE,1,nil,tp) then ct=ct+1 end
		if Duel.IsExistingTarget(c101223066.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then ct=ct+1 end
		if true then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223066.thfilter2,tp,LOCATION_DECK,0,1,nil) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223066.thfilter,tp,0,LOCATION_GRAVE,1,nil,tp) then
		ops[off]=aux.Stringid(101223066,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(c101223066.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(101223066,2)
		opval[off-1]=2
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(101223066,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223066.thfilter2,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(101223066,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223066.thfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,0,LOCATION_DECK)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223066.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,g1:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	elseif opval[op]==4 then	
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223066.thfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,0,LOCATION_DECK)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223066.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,g1:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end	
end
function c101223066.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local g1=Group.CreateGroup()
	g1:Merge(g2)
	if g1 and g then g1:Sub(g) end
	if g1 and g1:GetCount()>0 then
		local tc=g1:GetFirst()
		local gg=Duel.SelectMatchingCard(tp,c101223066.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if gg:GetCount()>0 then
			Duel.SendtoHand(gg,nil,REASON_EFFECT)
		end
	end
	if g and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end	
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		Duel.Recover(tp,2000,REASON_EFFECT)
	end
	if bit.band(val,2)==2 then
		local g4=Duel.SelectMatchingCard(tp,c101223066.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g4:GetCount()>0 then
			Duel.SendtoHand(g4,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g4)
		end
	end
end
function c101223066.thfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c101223066.thfilter1,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c101223066.thfilter1(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c101223066.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223066.thfilter2(c)
	return c:GetLevel()==4 and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end