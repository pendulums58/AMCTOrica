--시로키츠의 명령
function c101223059.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223059.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223059.tg)
	e1:SetOperation(c101223059.op)
	c:RegisterEffect(e1)		
end
function c101223059.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223059.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223059.conchk(c)
	return c:IsType(TYPE_XYZ)
end
function c101223059.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101223059.spfilter(chkc,e,tp))
		or (chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove()) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223059.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ct=ct+1 end
		if Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223059.thfilter,tp,LOCATION_DECK,0,1,nil) then ct=ct+1 end
		if true then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223059.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0	then
		ops[off]=aux.Stringid(101223059,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
		ops[off]=aux.Stringid(101223059,2)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223059.thfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(101223059,3)
		opval[off-1]=3
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(101223059,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223059.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223059.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
end
function c101223059.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if g and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local tc=g:GetFirst()
		if tc:IsRelateToEffect(e) then
			local lv=tc:GetLevel()
			if tc:IsType(TYPE_XYZ)  then lv=tc:GetRank() end
			local sp=Duel.SelectMatchingCard(tp,c101223059.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
			if sp:GetCount()>0 then
				Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	local ex2,g1=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	if g1 and g1:GetCount()>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end	
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g3=Duel.SelectMatchingCard(tp,c101223059.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g3:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g3)
		end
	end
	if bit.band(val,2)==2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c101223059.tgtg)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

function c101223059.spfilter(c,e,tp)
	local lv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then lv=c:GetRank() end
	return lv>0 and Duel.IsExistingMatchingCard(c101223059.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,lv)
end
function c101223059.spfilter1(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223059.thfilter(c)
	return c:IsSetCard(0x73) and c:IsAbleToHand()
end
function c101223059.tgtg(e,c)
	return c:IsType(TYPE_XYZ)
end