--헤일론의 명령
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
function s.cfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(g,1-tp)
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and c:IsLocation(LOCATION_REMOVED)
	end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) 
			and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,3,nil) then ct=ct+1 end	
		if Duel.IsExistingTarget(Card.IsCanBeSpecialSummoned,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,0,tp,false,false) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,2,nil) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) 
			and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,3,nil) then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(Card.IsCanBeSpecialSummoned,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,0,tp,false,false) then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end	
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,2,nil) then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP) then
		ops[off]=aux.Stringid(id,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
		local gg1=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,3,3,nil)
		g1:Merge(gg1)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,4,tp,LOCATION_ONFIELD)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,0,tp,false,false)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),tp,LOCATION_REMOVED)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,2,tp,LOCATION_DECK)
	elseif opval[op]==4 then
		e:SetLabel(e:GetLabel()+2)
		local g3=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g3,g3:GetCount(),tp,LOCATION_ONFIELD)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
		local gg1=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,3,3,nil)
		g1:Merge(gg1)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,4,tp,LOCATION_ONFIELD)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsCanBeSpecialSummoned,tp,0,LOCATION_REMOVED,1,1,nil,e,0,tp,false,false)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),tp,LOCATION_REMOVED)		
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,2,tp,LOCATION_DECK)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
		local g3=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g3,g3:GetCount(),tp,LOCATION_ONFIELD)
	end	
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)	
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local g1=Group.CreateGroup()
	if g2 then g1:Merge(g2) end
	if g and g1 then g1:Sub(g) end
	if g and g:GetCount()>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end	
	if g1:GetCount()>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		local tc=g1:GetFirst()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local g3=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,2,2,nil)
		if g3:GetCount()==2 then
			Duel.SendtoHand(g3,nil,REASON_EFFECT)
			Duel.ConfirmCards(g3,1-tp)
		end
	end
	if bit.band(val,2)==2 then
		local g4=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
		if g4:GetCount()>0 then
			Duel.SendtoHand(g4,nil,REASON_EFFECT)
		end
	end
end