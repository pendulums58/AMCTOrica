--발할라(Va-11 Hall-A)의 마스터 다나
function c101236002.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,101236002)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101236002.spcon)
	c:RegisterEffect(e1)
	--2번 효과
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CHEMICAL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101236002.cmtg)
	e3:SetOperation(c101236002.cmop)
	c:RegisterEffect(e3)
end
function c101236002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101236002.cmfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101236002.cmfilter(c)
	return c:IsFaceup() and c:IsCode(101236009)
end
function c101236002.cmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101236002.cmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101236002.cmfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101236002.cmfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101236002.cmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	yipi.SelectChemical(tp,tc)
end