--양단하는 환영검
function c101255007.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101255007,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,101255007)
	e2:SetTarget(c101255007.destg)
	e2:SetOperation(c101255007.desop)
	c:RegisterEffect(e2)	
	--생성한다
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(c101255007.spcon2)
	e3:SetOperation(c101255007.spop2)
	c:RegisterEffect(e3)
end
function c101255007.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x627)
end
function c101255007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101255007.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c101255007.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c101255007.ctfilter(c)
	return c:IsLocation(LOCATION_GRAVE)
end
function c101255007.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.BreakEffect()
	local ct=Duel.GetOperatedGroup():FilterCount(c101255007.ctfilter,nil)
	if ct==1 then
		Duel.Damage(1-tp,800,REASON_EFFECT,true)
		Duel.Damage(tp,800,REASON_EFFECT,true)
		Duel.RDComplete()
	end
	if ct==0 and Duel.SelectYesNo(tp,aux.Stringid(101255007,1)) then
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if dg:GetCount()>0 then Duel.SendtoGrave(dg,REASON_EFFECT) end
	end
end
function c101255007.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c101255007.spop2(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,101255008)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
end
