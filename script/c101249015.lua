--메모리큐어 - 일순간의 기억
function c101249015.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--카드명 변경
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101249015,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101249015)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101249015.target)
	e1:SetOperation(c101249015.operation)
	c:RegisterEffect(e1)
	--같은 종류 서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101249015,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x623))
	c:RegisterEffect(e2)
end
-- 변경 관련
function c101249015.spfilter1(c)
	return c:IsFaceup()
end
function c101249015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c101249015.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101249015.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c101249015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsSetCard(0x623) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(96765646)
		tc:RegisterEffect(e1)
	else
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(101249015,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(96765646)
		tc:RegisterEffect(e1)
	end
end