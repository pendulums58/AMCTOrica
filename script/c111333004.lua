--후부키류 - 호롱의 혼
function c111333004.initial_effect(c)
--융합
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,111333000,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),1,true,true)	
--자체 특소	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,111333004)
	e1:SetCost(c111333004.spco)		
	e1:SetCondition(c111333004.spcon)
	e1:SetTarget(c111333004.sptg)
	e1:SetOperation(c111333004.spop)
	c:RegisterEffect(e1)	
--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)	
	e2:SetCountLimit(1,111333504)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c111333004.condition)	
	e2:SetTarget(c111333004.target)
	e2:SetOperation(c111333004.activate)
	c:RegisterEffect(e2)	
end
--코스트
function c111333004.cfilter(c,tp)
	return c:IsCode(111333000) and c:IsAbleToGraveAsCost()
end
function c111333004.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111333004.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c111333004.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
--특소 컨디션
function c111333004.spcon(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(111333007) then
		for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler():IsCode(111333007) then 
		local tc=Duel.GetChainInfo(i-1,CHAININFO_TRIGGERING_EFFECT)
		if tc:IsHasCategory(CATEGORY_DESTROY) then return true  
		end 
		end
		end
	end	
end
--특소 타겟
function c111333004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(17946349,3))
end
--특소 효과
function c111333004.spop(e,tp,eg,ep,ev,re,r,rp)
--특소
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
--효과 교체	
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,c111333004.repop)
end
--교체될 효과
function c111333004.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
--파괴
function c111333004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>2
end
function c111333004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c111333004.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
