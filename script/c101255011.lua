--무환의 환영검
function c101255011.initial_effect(c)
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101255011.cost)
	e1:SetTarget(c101255011.target)
	e1:SetOperation(c101255011.activate)
	c:RegisterEffect(e1)
	--환영검 생성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c101255011.cost1)
	e2:SetTarget(c101255011.target1)
	e2:SetOperation(c101255011.operation)
	c:RegisterEffect(e2)
end
function c101255011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101255011.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101255011.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c101255011.cfilter(c)
	return c:IsSetCard(0x627) and c:IsDiscardable()
end
function c101255011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c101255011.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local ct=Duel.GetMatchingGroupCount(c101255011.cfilter1,tp,LOCATION_HAND,0,nil)
		local fc=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		local yn=1
		while (ct>0 and fc and yn) do
			if Duel.SelectYesNo(tp,aux.Stringid(101255011,0)) then
				local c=Duel.SelectMatchingCard(tp,c101255011.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
				if c:GetCount()>0 then
					Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
					local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
					if g1:GetCount()>0 then
						Duel.Destroy(g1,REASON_EFFECT)
					end
				end
			else
				yn=0
			end
			ct=Duel.GetMatchingGroupCount(c101255011.cfilter1,tp,LOCATION_HAND,0,nil)
			fc=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)	
		end
	end
end
function c101255011.cfilter1(c)
	return c:IsCode(101255008) and c:IsDiscardable()
end
function c101255011.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c101255011.cfilter2,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	local g1=Duel.GetMatchingGroup(c101255011.cfilter2,tp,LOCATION_MZONE,0,nil)
	local tc=g1:GetFirst()
	local g=Group.CreateGroup()
	while tc do
		if tc:IsType(TYPE_ACCESS) then
			local ad=tc:GetAdmin() 
			if ad and ad:IsAbleToGraveAsCost() then g:AddCard(ad) end
		end
		tc=g1:GetNext()
	end
	g=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101255011.cfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x627) and c:IsType(TYPE_ACCESS) and c:CheckRemoveAdmin(tp,1,REASON_COST)
end
function c101255011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
end
function c101255011.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local token=Duel.CreateToken(tp,101255008)
	g:AddCard(token)
	local token1=Duel.CreateToken(tp,101255008)
	g:AddCard(token1)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)	
end