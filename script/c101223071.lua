--심해의 명령
function c101223071.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223071.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223071.tg)
	e1:SetOperation(c101223071.op)
	c:RegisterEffect(e1)		
end
function c101223071.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223071.conchk,tp,LOCATION_MZONE,0,1,nil)
end
--조건
function c101223071.conchk(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
--2)튜너 특소 필터
function c101223071.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--3)물 속성 매장 필터
function c101223071.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGrave()
end
--4)내성 필터
function c101223071.infilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c101223071.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101223071.spfilter(chkc,e,tp))
		or (chkc:IsOnField() and chkc:IsAbleToRemove()) end
	if chk==0 then
		local ct=0
		--1)제외
		if Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then ct=ct+1 end	
		--2)특소	
		if Duel.IsExistingTarget(c101223071.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ct=ct+1 end
		--3)매장
		if Duel.IsExistingMatchingCard(c101223071.tgfilter,tp,LOCATION_DECK,0,1,nil) then ct=ct+1 end
		--4)내성
		if true then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	--1)제외
	if Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then
		ops[off]=aux.Stringid(101223071,1)
		opval[off-1]=1
		off=off+1
	end
	--2)특소
	if Duel.IsExistingTarget(c101223071.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0	then
		ops[off]=aux.Stringid(101223071,2)
		opval[off-1]=2
		off=off+1
	end	
	--3)매장
	if Duel.IsExistingMatchingCard(c101223071.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(101223071,3)
		opval[off-1]=3
		off=off+1
	end
	--4)내성
	if true then
		ops[off]=aux.Stringid(101223071,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	
--골라요 골라	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	--1)제외
	if opval[op]==1 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	elseif opval[op]==2 then
	--2)특소
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223071.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,LOCATION_GRAVE)	
	--3)매장	
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
	--4)내성	
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	--1)제외
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,LOCATION_ONFIELD)
	--2)특소	
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223071.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,LOCATION_GRAVE)	
	--3)매장	
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
	--4)내성	
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
end
--오퍼
function c101223071.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--1)제외
	local ex2,g1=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	if g1 and g1:GetCount()>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end		
	--2)특소
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if g and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	--3)매장
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local g3=Duel.SelectMatchingCard(tp,c101223071.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g3:GetCount()>0 then
			Duel.SendtoGrave(g3,REASON_EFFECT)
		end
	end
	--)내성
	if bit.band(val,2)==2 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c101223071.indtg1)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101223071.indtg1(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end