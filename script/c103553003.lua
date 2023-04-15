--검은안개 공방
function c103553003.initial_effect(c)
	aux.AddCodeList(c,103553000)
	--공격력 상승
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c103553003.atktg)
	e1:SetOperation(c103553003.atkop)
	c:RegisterEffect(e1)
	--내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c103553003.cost)
	e2:SetTarget(c103553003.imtg)
	e2:SetOperation(c103553003.imop)
	c:RegisterEffect(e2)
end
function c103553003.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsCode(103553000) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)	end
	if chk==0 then return Duel.IsExistingMatchingCard(c103553003.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c103553003.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c103553003.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c103553003.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c103553003.filter1,tp,LOCATION_GRAVE,0,nil)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(g:GetClassCount(Card.GetCode)*300)
		tc:RegisterEffect(e1)
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(c103553003.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tc:GetAttack())
			and cyan.IsUnlockState(e,tp) and Duel.SelectYesNo(tp,aux.Stringid(103553003,0)) then
			local gg=Duel.SelectMatchingCard(tp,c103553003.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc:GetAttack())
			if gg:GetCount()>0 then
				Duel.Destroy(gg,REASON_EFFECT)
			end
		end
	end
end
function c103553003.desfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function c103553003.filter1(c)
	return aux.IsCodeListed(c,103553000)
end
function c103553003.filter(c)
	return c:IsFaceup() and c:IsCode(103553000)
end
function c103553003.tdfilter(c)
	return aux.IsCodeListed(c,103553000) and c:IsAbleToDeckAsCost() and not c:IsCode(103553003)
end
function c103553003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c103553003.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>=1 and e:GetHandler():IsAbleToDeckAsCost() end
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,1)
	sg1:AddCard(e:GetHandler())
	Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c103553003.filter2(c)
	return c:IsFaceup() and c:IsCode(103553000)
end
function c103553003.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c103553003.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103553003.filter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c103553003.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c103553003.imop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c103553003.valcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		cyan.AddFuriosoStack(tp,1)
	end
end
function c103553003.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end