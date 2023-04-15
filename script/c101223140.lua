--프루던스 프라이드밸류
function c101223140.initial_effect(c)
--페어링 소환
	cyan.AddPairingProcedure(c,c101223140.pfilter,c101223140.mfilter,2,2)
	c:EnableReviveLimit()	
--페어 대상 내성
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c101223140.imval)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
--몬스터 효과 무효롸	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101223140,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)	
	e2:SetCountLimit(1)
	e2:SetCondition(c101223140.condition)
	e2:SetTarget(c101223140.target)
	e2:SetOperation(c101223140.operation)
	c:RegisterEffect(e2)
end
--페어링 소환
function c101223140.pfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c101223140.mfilter(c,pair)
	return c:GetLevel()<pair:GetLevel()
end
--페어 대상 내성
function c101223140.imval(e,c)
	local tc=e:GetHandler()
	return c:IsFaceup() and tc:GetPair():IsContains(c)
end
--몬스터 효과 무효화
function c101223140.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function c101223140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.NegateMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetChainLimit(c101223140.climit)	
end
function c101223140.climit(e,ep,tp)
	return tp==ep or e:GetHandler():IsType(TYPE_SPELL)
end
function c101223140.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end