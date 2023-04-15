--조 여환무장【엑소스피어】
function c101234034.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101234034.pfilter1,c101234034.pfilter2,1,1)
	c:EnableReviveLimit()
	--장착
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101234034)
	e1:SetTarget(c101234034.target)
	e1:SetOperation(c101234034.operation)
	c:RegisterEffect(e1)
end
function c101234034.pfilter1(c)
	return c:IsSetCard(0x611) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c101234034.pfilter2(c)
	return c:IsSetCard(0x611)
end
function c101234034.qfilter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
end
function c101234034.nfilter(c,tp)
	return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,c)
end
function c101234034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101234034.nfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101234034.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eq=Duel.SelectMatchingCard(tp,c101234034.qfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,tc)
	local eqc=eq:GetFirst()
	while eqc do
		if eqc and Duel.Equip(tp,eqc,tc) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c101234034.eqlimit)
			e1:SetLabelObject(tc)
			eqc:RegisterEffect(e1)
		end
		eqc=eq:GetNext()
	end
end
function c101234034.eqlimit(e,c)
	return c==e:GetLabelObject()
end