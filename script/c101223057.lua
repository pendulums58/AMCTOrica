--미카즈키의 명령
function c101223057.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223057.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223057.tg)
	e1:SetOperation(c101223057.op)
	c:RegisterEffect(e1)	
end
function c101223057.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223057.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223057.conchk(c)
	return c:IsType(TYPE_FUSION)
end
function c101223057.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101223057.salfilter(chkc))
		or (chkc:IsLocation(LOCATION_MZONE)) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223057.salfilter,tp,LOCATION_GRAVE,0,1,nil) then ct=ct+1 end
		if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223057.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ct=ct+1 end
		if Duel.IsExistingMatchingCard(c101223057.thffilter,tp,LOCATION_EXTRA,0,1,nil,tp) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(c101223057.salfilter,tp,LOCATION_GRAVE,0,1,nil) then
		ops[off]=aux.Stringid(101223057,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(101223057,2)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223057.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		ops[off]=aux.Stringid(101223057,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223057.thffilter,tp,LOCATION_EXTRA,0,1,nil,tp) then
		ops[off]=aux.Stringid(101223057,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223057.salfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c101223057.salfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		local ex2,g1=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
		if g1 then g:Merge(g1) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local ex2,g=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
		if g then g1:Merge(g) end	
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
	end	
end
function c101223057.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	if g and g:GetCount()>0 then
		local g1=g:Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
		end
		local g2=g:Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
		end		
	end
	local val=e:GetLabel()
	if bit.band(val,1)==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g3=Duel.SelectMatchingCard(tp,c101223057.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g3:GetCount()>0 then
			Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if bit.band(val,2)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local cg=Duel.SelectMatchingCard(tp,c101223057.thffilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
		if cg:GetCount()==0 then return end
		Duel.ConfirmCards(1-tp,cg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101223057.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,cg:GetFirst())
		local tc=g:GetFirst()
		if not tc then return end
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc) 
		end
	end
end

function c101223057.salfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:IsSetCard(0x46)
end
function c101223057.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223057.thffilter(c,tp)
	return c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(c101223057.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c101223057.filter2(c,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsAbleToHand()
end