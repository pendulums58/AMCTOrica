--홀로기움의 명령
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
	return c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(g,1-tp)
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
		(chkc:IsLocation(LOCATION_MZONE))
		or
		(chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE))
	end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,0) 
			and Duel.IsPlayerCanDraw(tp,1) then ct=ct+1 end	
		if Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then ct=ct+1 end
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then ct=ct+1 end
		if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,0) 
			and Duel.IsPlayerCanDraw(tp,1) then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER) then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end	
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(id,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,tp,LOCATION_ONFIELD)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
	elseif opval[op]==2 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	elseif opval[op]==3 then
		e:SetLabel(e:GetLabel()+1)
		local ch=Duel.GetCurrentChain()
		local mc=0
		for i=1,ch do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:GetHandlerPlayer()==tp then mc=mc+1 end
		end
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,mc,tp,LOCATION_ONFIELD)
	elseif opval[op]==4 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,tp,LOCATION_ONFIELD)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
	elseif opval[op1]==2 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)		
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
		local ch=Duel.GetCurrentChain()
		local mc=0
		for i=1,ch do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:GetHandlerPlayer()==tp then mc=mc+1 end
		end
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,mc,tp,LOCATION_ONFIELD)
	elseif opval[op1]==4 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end	
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)	
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local g1=Group.CreateGroup()
	if g2 then g1:Merge(g2) end
	if g and g1 then g1:Sub(g) end
	if g and g:GetCount()>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end	
	if g1:GetCount()>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		local tc=g1:GetFirst()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local gg1=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
			if gg1:GetCount()>0 then
				local ttc=gg1:GetFirst()
				Duel.Equip(tp,ttc,tc,false,eff)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(Card.EquipByEffectLimit)
				e1:SetLabelObject(tc)
				ttc:RegisterEffect(e1)
			end
		end
	end
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local ch=Duel.GetCurrentChain()
		local mc=0
		for i=1,ch do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:GetHandlerPlayer()==tp then mc=mc+1 end
		end
		local gg3=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,mc,e:GetHandler())
		if gg3:GetCount()>0 then
			Duel.Destroy(gg3,REASON_EFFECT)
		end
	end
	if bit.band(val,2)==2 then
		local g4=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g4:GetCount()>0 then
			Duel.SendtoHand(g4,nil,REASON_EFFECT)
			Duel.ConfirmCards(g4,1-tp)
		end
	end
end
function s.thfilter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsAttack(1500) and c:IsDefense(1000) and c:IsAbleToHand()
end