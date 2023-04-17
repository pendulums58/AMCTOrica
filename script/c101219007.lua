--라디언트 라이트
local s,id=GetID()
function s.initial_effect(c)
	--무효화
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id+100)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(s.thcon)
	cyan.JustSearch(e2,LOCATION_DECK,Card.IsSetCard,SETCARD_RADIANT,Card.IsType,TYPE_MONSTER,Card.IsType,TYPE_RITUAL)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	g:Merge(g1)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)			
		tc=g:GetNext()		
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsControler(1-tp) and not chkc:IsDisabled() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsNegatable,tp,0,LOCATION_ONFIELD,1,nil) end
	local tc=Duel.SelectTarget(tp,Card.IsNegatable,tp,0,LOCATION_ONFIELD,1,2,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local c=e:GetHandler()
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	sg=sg:Filter(Card.IsNegatable,nil)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
			tc=sg:GetNext()
		end
	end	
end
function s.cfilter(c)
	return c:IsSetCard(SETCARD_RADIANT) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and not c:IsPublic()
end
function s.cfilter1(c)
	return c:IsSetCard(SETCARD_RADIANT) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and not c:IsPublic()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.thchk,tp,LOCATION_GRAVE,0,1,nil)
end
function s.thchk(c)
	return c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end