--후부키류 - 파도의 영
function c111333002.initial_effect(c)
--융합
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,111333000,aux.FilterBoolFunction(Card.IsAttack,0),1,true,true)
--자체 특소	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,111333002)	
	e1:SetCost(c111333002.spco)	
	e1:SetCondition(c111333002.spcon)
	e1:SetTarget(c111333002.sptg)
	e1:SetOperation(c111333002.spop)
	c:RegisterEffect(e1)		
--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,111333502)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c111333002.condition)	
	e2:SetTarget(c111333002.target)
	e2:SetOperation(c111333002.activate)
	c:RegisterEffect(e2)
end
--코스트
function c111333002.cfilter(c,tp)
	return c:IsCode(111333000) and c:IsAbleToGraveAsCost()
end
function c111333002.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111333002.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c111333002.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
--특소 컨디션
function c111333002.spcon(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(111333007) then
		for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler():IsCode(111333007) then 
		local tc=Duel.GetChainInfo(i-1,CHAININFO_TRIGGERING_EFFECT)
		if tc:IsHasCategory(CATEGORY_DRAW) or tc:IsHasCategory(CATEGORY_SEARCH) then return true  
		end
		end 
		end
	end	
end
--특소 타겟
function c111333002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(17946349,3))
end
--특소 효과
function c111333002.spop(e,tp,eg,ep,ev,re,r,rp)
--특소
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
--효과 교체	
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,c111333002.repop)
end
--교체될 효과
function c111333002.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

--서치
function c111333002.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>2
end
function c111333002.filter(c,e,tp)
	return c:IsSetCard(0x649) and c:IsAbleToHand()
end
function c111333002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c111333002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111333002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111333002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
