--일시적 찬탈
function c101241002.initial_effect(c)
	--소생
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101241002)
	e1:SetTarget(c101241002.tg)
	e1:SetOperation(c101241002.op)
	c:RegisterEffect(e1)
end
function c101241002.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x605)
end
function c101241002.gfilter(c,e,tp)
	return c:IsType(TYPE_ACCESS) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101241002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c101241002.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101241002.gfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SelectTarget(tp,c101241002.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101241002.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c101241002.gfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if tc:IsRelateToEffect(e) and g:GetCount()>0 then
		local gc=g:GetFirst()
		Duel.SpecialSummon(gc,0,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(gc,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		gc:RegisterEffect(e1)
	end
end