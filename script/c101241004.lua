--창세의 서
function c101241004.initial_effect(c)
	--소생
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101241004)
	e1:SetTarget(c101241004.tg)
	e1:SetOperation(c101241004.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c101241004.descon)
	e2:SetOperation(c101241004.desop)
	c:RegisterEffect(e2)
end
function c101241004.gfilter(c,e,tp)
	return c:IsType(TYPE_ACCESS) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101241004.cfilter(c,tc)
	return c:IsType(TYPE_MONSTER) and cyan.IsCanBeAccessMaterial(c,tc)
end
function c101241004.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c101241004.gfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101241004.gfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp)
	and Duel.IsExistingTarget(c101241004.cfilter,tp,LOCATION_MZONE,0,1,nil,tc)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,c101241004.gfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101241004.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetFirstTarget()
	local tc=Duel.SelectMatchingCard(tp,c101241004.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:IsRelateToEffect(e) and tc:GetCount()>0 then
		local gc=g:GetFirst()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(gc,tc)
		Duel.Equip(tp,e:GetHandler(),gc)
		--Add Equip limit
		local e1=Effect.CreateEffect(gc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c101241004.eqlimit)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c101241004.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget():GetAdmin()
	return tc==nil
end
function c101241004.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c101241004.eqlimit(e,c)
	return e:GetOwner()==c
end