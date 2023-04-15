--매장자의 명령
function c101223068.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223068.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223068.tg)
	e1:SetOperation(c101223068.op)
	c:RegisterEffect(e1)	
end
function c101223068.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223068.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223068.conchk(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c101223068.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101223068.spfilter(chkc,e,tp))
		or (chkc:IsLocation(LOCATION_MZONE) and c101223068.fdfilter(chkc)) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223068.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then ct=ct+1 end
		if Duel.IsExistingTarget(c101223068.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then ct=ct+1 end
		if true then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223068.tgfilter,tp,LOCATION_DECK,0,1,nil) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223068.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(101223068,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(c101223068.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(101223068,2)
		opval[off-1]=2
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(101223068,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223068.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(101223068,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223068.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_POSITION)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223068.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,g1:GetCount(),0,LOCATION_MZONE)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223068.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_POSITION)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223068.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,g1:GetCount(),0,LOCATION_MZONE)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
	end	
end
function c101223068.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local ex1,g1=Duel.GetOperationInfo(0,CATEGORY_POSITION)
	if g and g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	if g1 and g1:GetCount()>0 then
		local tc1=g1:GetFirst()
		if tc1:IsRelateToEffect(e) and tc1:IsLocation(LOCATION_MZONE) and tc1:IsFaceup() then
			Duel.ChangePosition(tc1,POS_FACEDOWN_DEFENSE)
		end
	end	
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(c101223068.damval)
		e1:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e1,tp)
	end
	if bit.band(val,2)==2 then
		local g3=Duel.SelectMatchingCard(tp,c101223068.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g3:GetCount()>0 then
			Duel.SendtoGrave(g3,REASON_EFFECT)
		end
	end
end
function c101223068.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101223068.fdfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c101223068.damval(e,re,val,r,rp,rc)
	return math.floor(val/2)
end
function c101223068.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGrave()
end