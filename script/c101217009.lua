--에고파인더 노우렛지
function c101217009.initial_effect(c)
	--소환
	aux.AddXyzProcedure(c,c101217009.ovfilter1,4,2,c101217009.ovfilter2,aux.Stringid(101217009,0),2,c101217009.xyzop)
	c:EnableReviveLimit()
	
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101217009.cost)
	e1:SetTarget(c101217009.destg)
	e1:SetOperation(c101217009.desop)
	c:RegisterEffect(e1)
end
function c101217009.ovfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xef7)
end
function c101217009.ovfilter2(c)
	return c:IsFaceup() and c:IsCode(101217000)
end
function c101217009.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101217009)==0 end
	Duel.RegisterFlagEffect(tp,101217009,RESET_PHASE+PHASE_END,0,1)
	return true
end
function c101217009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101217009.filter(c)
	return c:IsFacedown()
end
function c101217009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c101217009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101217009.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101217009.filter,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101217009.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end	 