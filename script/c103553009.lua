--크루거 인더스트리
function c103553009.initial_effect(c)
	aux.AddCodeList(c,103553000)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c103553009.target)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetOperation(c103553009.activate)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetCondition(c103553009.addcon)
	c:RegisterEffect(e0)
	--묘지 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103553009,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c103553009.tdcost)
	e2:SetCondition(c103553009.spcon)
	e2:SetTarget(c103553009.thtg)
	e2:SetOperation(c103553009.thop)
	c:RegisterEffect(e2)
end
function c103553009.Inarichk(c)
	return c:IsFaceup() and c:IsCode(103553000)
end
function c103553009.addcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c103553009.Inarichk,tp,LOCATION_MZONE,0,1,nil)
end
function c103553009.filter(c,tp,chk)
	if not (c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE)) then return false end
	if cyan.IsUnlockState(c,tp) and not c:IsAbleToDeck() then return false end
	return c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c103553009.filter1(c,tp,chk,g)
	if not (c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE)) then return false end
	if cyan.IsUnlockState(c,tp) and not c:IsAbleToDeck() then return false end
	return c:IsType(TYPE_EFFECT) and not c:IsDisabled() and g:IsContains(c)
end
function c103553009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c103553009.filter,nil,tp,chk)
	if chkc then g:IsContains(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103553009.filter1,tp,0,LOCATION_MZONE,1,nil,tp,chk,g) end
	local tc=Duel.SelectTarget(tp,c103553009.filter1,tp,0,LOCATION_MZONE,1,1,nil,tp,chk,g)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
	if cyan.IsUnlockState(e,tp) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	end
end
function c103553009.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	Duel.BreakEffect()
	if cyan.IsUnlockState(e,tp) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c103553009.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsPreviousCode(103553000)
		and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c103553009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c103553009.cfilter,1,nil,tp,rp)
end
function c103553009.tdfilter(c)
	return aux.IsCodeListed(c,103553000) and c:IsAbleToDeckAsCost() and not c:IsCode(103553009)
end
function c103553009.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c103553009.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>=1 and e:GetHandler():IsAbleToDeckAsCost() end
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,1)
	sg1:AddCard(e:GetHandler())
	Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c103553009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c103553009.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		cyan.AddFuriosoStack(tp,1)
	end
end