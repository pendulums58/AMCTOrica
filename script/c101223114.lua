--꽁기깅깅깅공강강꽁기깅깅꽁기깅강
function c101223114.initial_effect(c)
	--꽁기깅강...꽁기깅강...
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101223114)
	e1:SetTarget(c101223114.tg)
	e1:SetOperation(c101223114.op)
	c:RegisterEffect(e1)
end
function c101223114.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsType(TYPE_EFFECT) and ((chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup()) or chkc:IsLocation(LOCATION_GRAVE))
		and chkc:IsControler(1-tp) end
	if chk==0 then Duel.IsExistingTarget(c101223114.tgfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	local tc=Duel.SelectTarget(tp,c101223114.tgfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
end
function c101223114.tgfilter(c)
	return c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()
end
function c101223114.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetRange(LOCATION_GRAVE)
		tc:RegisterEffect(e2)
	end
end