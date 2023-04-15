--모르트의 명령
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)	
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(g,1-tp)
	end
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_FIELD)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
		(chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged())
		or
		(chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) and chkc:IsControler(1-tp))
	end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) then ct=ct+1 end	
		if Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ct=ct+1 end
		if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then ct=ct+1 end
		if Duel.AmassCheck(tp) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end	
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.AmassCheck(tp) then
		ops[off]=aux.Stringid(id,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_CONTROL)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g1=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,1,0,0)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),tp,LOCATION_GRAVE)	
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_CONTROL)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g1=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,1,0,0)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),tp,LOCATION_GRAVE)		
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
end
function s.cfilter(c)
	return c:IsType(TYPE_FIELD) and not c:IsPublic()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex1,g=Duel.GetOperationInfo(0,CATEGORY_CONTROL)
	local ex2,g1=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if g and g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsRelateToEffect(e) then
			Duel.GetControl(tc,tp,PHASE_END,2)
		end
	end
	if g1 and g1:GetCount()>0 then
		if g1:GetFirst():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local g3=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g3:GetCount()>0 then
			Duel.SendtoHand(g3,nil,REASON_EFFECT)
			Duel.ConfirmCards(g3,1-tp)
		end
	end
	if bit.band(val,2)==2 then
		Duel.Amass(e,2300)	
	end
end