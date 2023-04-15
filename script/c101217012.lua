--에고파인더 트랜센던스
function c101217012.initial_effect(c)
	--소환
	aux.AddXyzProcedure(c,c101217012.ovfilter1,4,2,c101217012.ovfilter2,aux.Stringid(101217012,0),2,c101217012.xyzop)
	c:EnableReviveLimit()
	
	--1번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101217012.discon)
	e2:SetCost(c101217012.cost)
	e2:SetTarget(c101217012.distg)
	e2:SetOperation(c101217012.disop)
	c:RegisterEffect(e2)
	
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c101217012.adtg)
	e2:SetOperation(c101217012.activate)
	c:RegisterEffect(e2)
end
function c101217012.ovfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xef7)
end
function c101217012.ovfilter2(c)
	return c:IsFaceup() and c:IsCode(101217000)
end
function c101217012.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101217012)==0 end
	Duel.RegisterFlagEffect(tp,101217012,RESET_PHASE+PHASE_END,0,1)
	return true
end
function c101217012.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and e:GetHandler():GetOverlayGroup()
end
function c101217012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101217012.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101217012.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c101217012.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101217012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101217012.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101217012.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101217012.filter(c)
	return c:IsFaceup() and c:IsCode(101217010)
end
function c101217012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end