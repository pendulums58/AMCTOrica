--시계탑 자동방위장치
function c101213300.initial_effect(c)
	--무효로 하고 파괴한다
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101213300,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(c101213300.negcon)
	e1:SetCost(c101213300.negcost)
	e1:SetTarget(c101213300.negtg)
	e1:SetOperation(c101213300.negop)
	c:RegisterEffect(e1)
	--묘지에서 특수 소환한다
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101213300)
	e2:SetCost(c101213300.spcost)
	e2:SetTarget(c101213300.sptg)
	e2:SetOperation(c101213300.spop)
	c:RegisterEffect(e2)	
end
function c101213300.negfilter(c,tp)
	return c:IsFaceup() and c:IsCode(75041269) and c:IsControler(tp) 
end
function c101213300.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101213300.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	if rp==tp then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c101213300.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c101213300.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101213300.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,c101213300.negfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		if g:GetCount()>0 then
			tc=g:GetFirst()
			tc:AddCounter(0x1b,2)
		end
	end
end
function c101213300.spcfilter(c,tp)
	return c:IsCode(75041269) and c:IsCanRemoveCounter(tp,0x1b,1,REASON_COST)
end
function c101213300.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101213300.spcfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local tc=g:GetFirst()
	if chk==0 then return tc end
	tc:RemoveCounter(tp,0x1b,1,REASON_COST)
end
function c101213300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101213300.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)  then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end