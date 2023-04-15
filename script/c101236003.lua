--발할라(Va-11 Hall-A)의 보안양 미드
function c101236003.initial_effect(c)
	--페어링
	c:EnableReviveLimit()
	--특소 조건
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101236003.splimit)
	c:RegisterEffect(e1)
	--1번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CHEMICAL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101236003)
	e2:SetCost(c101236003.cost)
	e2:SetTarget(c101236003.cmtg)
	e2:SetOperation(c101236003.cmop)
	c:RegisterEffect(e2)
	--2번 효과
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101236003.con)
	e3:SetTarget(c101236003.target)
	e3:SetOperation(c101236003.activate)
	c:RegisterEffect(e3)
end
function c101236003.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(101236021) or se:GetHandler():IsCode(101236008) or se:GetHandler():IsCode(101236011)
end
function c101236003.cfilter(c)
	return c:IsSetCard(0x660)
end
function c101236003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101236003.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c101236003.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c101236003.cmfilter(c)
	return c:IsFaceup() and c:IsCode(101236009)
end
function c101236003.cmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101236003.cmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101236003.cmfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101236003.cmfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101236003.cmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	yipi.SelectChemical(tp,tc)
	if Duel.SelectYesNo(tp,aux.Stringid(101236003,0)) then
		yipi.SelectChemical(tp,tc)
	end
end
function c101236003.sfilter(c)
	return not c:IsCode(101236003)
end
function c101236003.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101236003.sfilter,1,nil) and rp==tp and re:IsHasProperty(EFFECT_FLAG2_CHEMICAL)
end
function c101236003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ftg=re:GetTarget()
	if chkc then return ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk) end
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c101236003.activate(e,tp,eg,ep,ev,re,r,rp)
	local fop=re:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end