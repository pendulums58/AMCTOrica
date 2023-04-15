--횃불의 명령
function c101223070.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223070.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223070.tg)
	e1:SetOperation(c101223070.op)
	c:RegisterEffect(e1)	
end
function c101223070.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223070.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223070.conchk(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c101223070.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c101223070.rmfilter(chkc))
		or (chkc:IsLocation(LOCATION_ONFIELD) and chkc~=e:GetHandler()) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223070.rmfilter,tp,0,LOCATION_GRAVE,1,nil) then ct=ct+1 end
		if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
			and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_HAND,0,1,nil,ATTRIBUTE_FIRE) then ct=ct+1 end
		if Duel.CheckReleaseGroup(tp,c101223070.relfilter,1,nil)
			and Duel.IsExistingMatchingCard(c101223070.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then ct=ct+1 end
		if true then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223070.rmfilter,tp,0,LOCATION_GRAVE,1,nil) then
		ops[off]=aux.Stringid(101223070,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
			and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_HAND,0,1,nil,ATTRIBUTE_FIRE) then
		ops[off]=aux.Stringid(101223070,2)
		opval[off-1]=2
		off=off+1
	end
	if Duel.CheckReleaseGroup(tp,c101223070.relfilter,1,nil)
			and Duel.IsExistingMatchingCard(c101223070.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(101223070,3)
		opval[off-1]=3
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(101223070,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223070.rmfilter,tp,0,LOCATION_GRAVE,1,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op]==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223070.rmfilter,tp,0,LOCATION_GRAVE,1,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,LOCATION_GRAVE)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op1]==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	end	
end
function c101223070.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local ex1,g1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	if g and g:GetCount()>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if g1 and g1:GetCount()>0 then
		local tc1=g1:GetFirst()
		if tc1:IsRelateToEffect(e) then
			local tc2=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_HAND,0,1,1,nil,ATTRIBUTE_FIRE)
			if tc2:GetCount()>0 then
				Duel.Destroy(tc2,REASON_EFFECT)
				Duel.Destroy(tc1,REASON_EFFECT)
			end
		end
	end	
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local g=Duel.SelectReleaseGroup(tp,c101223070.relfilter,1,1,nil)
		if Duel.Release(g,REASON_EFFECT)~=0 then
			local g3=Duel.SelectMatchingCard(tp,c101223070.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g3:GetCount()>0 then
				Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	if bit.band(val,2)==2 then
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
function c101223070.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c101223070.relfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c101223070.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelBelow(4)
end