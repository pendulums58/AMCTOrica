--순수의 결연희
function c101213009.initial_effect(c)
	--링크 소환
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101213009.matfilter,1,1)
	
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101213009,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xef3))
	c:RegisterEffect(e1)
	
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCountLimit(1,101213009)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101213009.damcon)
	e2:SetTarget(c101213009.target)
	e2:SetOperation(c101213009.operation)
	c:RegisterEffect(e2)
	
end
function c101213009.matfilter(c,lc,sumtype,tp)
	return c:IsRace(RACE_PSYCHO) and ((c:IsType(TYPE_LINK) and c:GetLink()>1) or not c:IsType(TYPE_LINK))
end

function c101213009.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ic=e:GetHandler():GetMutualLinkedGroup()
	return ic:IsExists(Card.IsCode,1,nil,101213012)
end
function c101213009.filter2(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c101213009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c101213009.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101213009.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101213009.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c101213009.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end