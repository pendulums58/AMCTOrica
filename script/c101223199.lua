--무라쿠모의 명령
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
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and not c:IsPublic()
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
		(chkc:IsOnField())
		or
		(chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE))
	end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then ct=ct+1 end	
		if Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then ct=ct+1 end
		if true then ct=ct+1 end
		if Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end	
	if true then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		ops[off]=aux.Stringid(id,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,tp,LOCATION_ONFIELD)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
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
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,tp,LOCATION_ONFIELD)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)		
	elseif opval[op1]==3 then
		e:SetLabel(e:GetLabel()+1)
	elseif opval[op1]==4 then
		e:SetLabel(e:GetLabel()+2)
	end	
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)	
	local ex2,g=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	local g1=Group.CreateGroup()
	if g2 then g1:Merge(g2) end
	if g and g1 then g1:Sub(g) end
	if g and g:GetCount()>0 then
		g=g:Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end	
	if g1:GetCount()>0 then
		g1=g1:Filter(Card.IsRelateToEffect,nil,e)
		local tc=g1:GetFirst()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(2500)
			tc:RegisterEffect(e1)
		end
	end
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local token=Duel.CreateToken(tp,101255008)
		Duel.SendtoHand(token,tp,REASON_EFFECT)
		local token1=Duel.CreateToken(tp,101255008)
		Duel.SendtoHand(token1,tp,REASON_EFFECT)
		local token2=Duel.CreateToken(tp,101255008)
		Duel.SendtoHand(token2,tp,REASON_EFFECT)
		local token3=Duel.CreateToken(tp,101255008)
		Duel.SendtoHand(token3,tp,REASON_EFFECT)
		local g3=Group.CreateGroup()
		g3:AddCard(token)
		g3:AddCard(token1)
		g3:AddCard(token2)
		g3:AddCard(token3)
		Duel.ConfirmCards(1-tp,g3)
	end
	if bit.band(val,2)==2 then
		local g4=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g4:GetCount()>0 then
			local ttc=g4:GetFirst()
			local g5=Duel.SelectMatchingCard(tp,s.eqchk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ttc)
			if g5:GetCount()>0 then
				local ttc1=g5:GetFirst()
				Duel.Equip(tp,ttc,ttc1)
			end
		end
	end
end
function s.eqfilter(c)
	local tp=c:GetControler()
	return c:IsType(TYPE_EQUIP) and Duel.IsExistingMatchingCard(s.eqchk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function s.eqchk(c,ec)
	return ec:CheckEquipTarget(c) and c:IsFaceup()
end