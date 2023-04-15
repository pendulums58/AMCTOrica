--달빛아래 명령
function c101223053.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223053.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223053.tg)
	e1:SetOperation(c101223053.op)
	c:RegisterEffect(e1)	
end
function c101223053.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223053.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223053.conchk(c)
	return c:IsType(TYPE_LINK) and c:GetLink()>=2 and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c101223053.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=Duel.GetLinkedZone(tp)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) and c101223053.seqfilter(chkc))
		or (chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101223053.spfilter(chkc,e,tp,zone)) end
	if chk==0 then
		local ct=2
		if Duel.IsExistingTarget(c101223053.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then ct=ct+1 end
		if Duel.IsExistingTarget(c101223053.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223053.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(101223053,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(c101223053.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) then
		ops[off]=aux.Stringid(101223053,2)
		opval[off-1]=2
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(101223053,3)
		opval[off-1]=3
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(101223053,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223053.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223053.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223053.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223053.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
end
function c101223053.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)	
	local ex1,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	g1:Sub(g)
	if g1 and g1:GetCount()>0 then
		local tc=g1:GetFirst()
		if tc:IsRelateToEffect(e) and not (tc:IsImmuneToEffect(e)
			or Duel.GetLocationCount(ttp,LOCATION_MZONE,PLAYER_NONE,0)<=0) then 
			local p1,p2
			if tc:IsControler(tp) then
				p1=LOCATION_MZONE
				p2=0
			else
				p1=0
				p2=LOCATION_MZONE
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local seq=math.log(Duel.SelectDisableField(tp,1,p1,p2,0),2)
			if tc:IsControler(1-tp) then seq=seq-16 end
			Duel.MoveSequence(tc,seq)
		end
	end
	if g and g:GetCount()>0 then
		local tc1=g:GetFirst()
		local zone=Duel.GetLinkedZone(tp)
		if tc1:IsRelateToEffect(e) and zone~=0 then
			Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c101223053.indtg)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if bit.band(val,2)==2 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c101223053.indtg1)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101223053.indtg(e,c)
	local seq=c:GetSequence()
	return seq==0 or seq==2 or seq==4
end
function c101223053.indtg1(e,c)
	local seq=c:GetSequence()
	return seq==1 or seq==3
end
function c101223053.atkval(e,c)
	return c:GetBaseAttack()
end
function c101223053.seqfilter(c)
	local tp=c:GetControler()
	return c:IsFaceup() and c:GetSequence() and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
end
function c101223053.spfilter(c,e,tp,zone)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101223053.adfilter(c)
	return c:IsType(TYPE_ACCESS) and c:GetAdmin()~=nil
end
function c101223053.atkfilter(c)
	return c:GetAttack()~=c:GetBaseAttack()
end