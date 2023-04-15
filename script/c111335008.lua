--개와 늑대의 시간
function c111335008.initial_effect(c)
--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c111335008.target)
	e1:SetOperation(c111335008.activate)
	c:RegisterEffect(e1)
--일반 소환	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111335008,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)	
	e2:SetCountLimit(1)
	e2:SetCost(c111335008.cost)
	e2:SetTarget(c111335008.sumtg)
	e2:SetOperation(c111335008.sumop)
	c:RegisterEffect(e2)
end
c111335008.remove_counter=0x326 
--발동
function c111335008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsCanRemoveCounter(tp,1,0,0x326,1,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(111335008,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		Duel.RemoveCounter(tp,1,0,0x326,1,REASON_COST)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end	
function c111335008.filter(c,e,tp)
	return c:IsFaceup() and c:IsCode(111335009)
end
function c111335008.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():IsRelateToEffect(e) and e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(c111335008.filter,tp,LOCATION_SZONE,0,nil,0x326,1)
		local tc=g:GetFirst()
		while tc do
		tc:AddCounter(0x326,1)
		tc=g:GetNext()
		end	
	end
end
--일반 소환
function c111335008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x326,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x326,1,REASON_COST)
end
function c111335008.sumfilter(c)
	return c:IsSetCard(0x652) and c:IsSummonable(true,nil)
end
function c111335008.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111335008.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c111335008.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c111335008.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end