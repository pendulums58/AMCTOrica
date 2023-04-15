--진동 포에머
function c101223016.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101223016)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101223016.condition)
	e1:SetCost(c101223016.cost)
	e1:SetTarget(c101223016.target)
	e1:SetOperation(c101223016.activate)
	c:RegisterEffect(e1)
	--발동했는지 체크
	Duel.AddCustomActivityCounter(101223016,ACTIVITY_CHAIN,c101223016.chainfilter)	
end
function c101223016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101223016.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_QUICKPLAY))
end
function c101223016.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetCustomActivityCount(101223016,tp,ACTIVITY_CHAIN)>1 and 
		Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c101223016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101223016.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.HintSelection(g)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
