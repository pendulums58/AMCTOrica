--메모리큐어 - 페리윙클
function c101249010.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FALSE,8,3,c101249010.ovfilter,aux.Stringid(101249010,0),3,c101249010.xyzop)   
	c:EnableReviveLimit()

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c101249010.xyzlimit)
	c:RegisterEffect(e0)

	--효과 무효화 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101249010.efilter)
	c:RegisterEffect(e1)
	--샐비지 및 파괴
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101249010,1))
	e2:SetCountLimit(1,101249010)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c101249010.tdcost)
	e2:SetTarget(c101249010.tdtg)
	e2:SetOperation(c101249010.tdop)
	c:RegisterEffect(e2)
end
function c101249009.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x623)
end
function c101249010.ovfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_XYZ) and c:IsSetCard(0x623))
end
function c101249010.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101249010.sfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,2,mc) end
	local g=Duel.SelectMatchingCard(tp,c101249010.sfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,2,2,mc)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
--효과 무효화 내성 관련
function c101249010.sfilter(c)
	return (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x623)) or c:IsCode(96765646)
end
function c101249010.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsSetCard(0x623)
end
--샐비지 및 파괴 관련
function c101249010.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101249010.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c101249010.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101249010.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function c101249010.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c101249010.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil,e)
	local ct=Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local brg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()>=0 and Duel.SelectYesNo(tp,aux.Stringid(101249010,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg2=brg:Select(tp,0,1,nil)
		Duel.Destroy(sg2,REASON_EFFECT)
	end
end 
function c101249010.tdfilter(c)
	return c:IsSetCard(0x623) and c:IsAbleToDeck() and c:IsFaceup()
end