--코덱스 프로토타입
function c103553007.initial_effect(c)
	aux.AddCodeList(c,103553000)
	--부여
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c103553007.target)
	e1:SetOperation(c103553007.activate)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c103553007.tdcost)
	e2:SetTarget(c103553007.destg)
	e2:SetOperation(c103553007.desop)
	c:RegisterEffect(e2)
end
function c103553007.filter(c)
	return c:IsFaceup()
end
function c103553007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c103553007.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103553007.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c103553007.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c103553007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		if tc:IsCode(103553000) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
		if cyan.IsUnlockState(e,tp) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(103553007,0))
			e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e2:SetCode(EVENT_BATTLE_DESTROYING)
			e2:SetLabelObject(tc)
			e2:SetCondition(c103553007.shcon)
			e2:SetTarget(c103553007.shtg)
			e2:SetOperation(c103553007.shop)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EFFECT_DESTROY_REPLACE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCondition(c103553007.regcon)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)	
		end
	end
end
function c103553007.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetBattleTarget() and r==REASON_BATTLE then
		c:RegisterFlagEffect(103553007,RESET_PHASE+PHASE_DAMAGE,0,1)
	end
	return false
end
function c103553007.shcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(103553007)~=0
end
function c103553007.shfilter(c)
	return aux.IsCodeListed(c,103553000) and c:IsAbleToHand()
end
function c103553007.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103553007.shfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c103553007.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c103553007.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c103553007.tdfilter(c)
	return aux.IsCodeListed(c,103553000) and c:IsAbleToDeckAsCost() and not c:IsCode(103553007)
end
function c103553007.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c103553007.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>=1 and e:GetHandler():IsAbleToDeckAsCost() end
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,1)
	sg1:AddCard(e:GetHandler())
	Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c103553007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c103553007.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103553007.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local tc=Duel.SelectTarget(tp,c103553007.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c103553007.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		cyan.AddFuriosoStack(tp,1)
	end
end
function c103553007.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end