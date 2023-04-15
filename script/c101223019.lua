--눈발 속의 미스디렉터
function c101223019.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223019.pfilter,c101223019.mfilter,1,1)
	c:EnableReviveLimit()
	--무효화
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101223019,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1)
	e1:SetTarget(c101223019.target)
	e1:SetOperation(c101223019.operation)
	c:RegisterEffect(e1)	
end
function c101223019.pfilter(c)
	return c:IsType(TYPE_SYNCHRO)
end
function c101223019.mfilter(c,pair)
	return c:IsAttribute(pair:GetAttribute) and not c:IsRace(pair:GetRace())
end	
function c101223019.negfilter(c,pr)	
	return aux.disfilter1(c) and pr:IsExists(Card.IsAttackAbove,1,nil,c:GetAttack()+1)
end
function c101223019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local pr=e:GetHandler():GetPair()
	if chkc then return chkc:IsOnField() and c101223019.negfilter(chkc,pr) end
	if chk==0 then return Duel.IsExistingTarget(c101223019.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,pr) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.c101223019.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,pr)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c101223019.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end