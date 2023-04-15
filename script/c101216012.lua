--성설의 눈싸라기
function c101216012.initial_effect(c)
	--효과 변환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101216012.condition)
	e1:SetCost(c101216012.cost)
	e1:SetTarget(c101216012.chtg)
	e1:SetOperation(c101216012.chop)
	c:RegisterEffect(e1)	
end
function c101216012.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c101216012.cfilter(c)
	return c:IsCode(89181369) and not c:IsPublic()
end
function c101216012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101216012.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101216012.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c101216012.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local rg=Duel.GetMatchingGroup(c101216012.rmfilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(c101216012.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,rg)
	end
end
function c101216012.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c101216012.activate)
end
function c101216012.spfilter(c,e,tp,rg)
	if not c:IsType(TYPE_SYNCHRO) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	if rg:IsContains(c) then
		rg:RemoveCard(c)
		result=rg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99)
		rg:AddCard(c)
	else
		result=rg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99)
	end
	return result
end
function c101216012.rmfilter(c)
	return c:GetLevel()>0 and c:IsAbleToRemove()
end
function c101216012.activate(e,tp,eg,ep,ev,re,r,rp)
	tp=1-tp
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local rg=Duel.GetMatchingGroup(c101216012.rmfilter,tp,LOCATION_GRAVE,0,nil)
	local g=Duel.SelectMatchingCard(tp,c101216012.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,rg)
	local g1=g:GetFirst()
	if g1 then
		rg:RemoveCard(g1)
		if rg:CheckWithSumEqual(Card.GetLevel,g1:GetLevel(),1,99) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rm=rg:SelectWithSumEqual(tp,Card.GetLevel,g1:GetLevel(),1,99)
			Duel.Remove(rm,POS_FACEUP,REASON_EFFECT)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end	
	end
	
end
