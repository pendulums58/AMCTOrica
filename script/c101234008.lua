--여환무장 -개벽-
function c101234008.initial_effect(c)
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetCountLimit(1,101234008)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101234008.eqtg)
	e1:SetOperation(c101234008.eqop)
	c:RegisterEffect(e1)
end
function c101234008.tgfilter(c,tp)
	local att=c:GetAttribute()
	return c:IsSetCard(0x611) and Duel.IsExistingMatchingCard(c101234008.eqfilter,tp,LOCATION_DECK,0,1,nil,att)
end
function c101234008.eqfilter(c,att)
	local tgatt=0
	if att==ATTRIBUTE_EARTH then tgatt=ATTRIBUTE_WIND end
	if att==ATTRIBUTE_WIND then tgatt=ATTRIBUTE_EARTH end
	if att==ATTRIBUTE_FIRE then tgatt=ATTRIBUTE_WATER end
	if att==ATTRIBUTE_WATER then tgatt=ATTRIBUTE_FIRE end
	if att==ATTRIBUTE_DARK then tgatt=ATTRIBUTE_LIGHT end
	if att==ATTRIBUTE_LIGHT then tgatt=ATTRIBUTE_DARK end
	if tgatt==0 then return false end
	return c:IsSetCard(0x611) and c:IsAttribute(tgatt)
end
function c101234008.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct1,ct2=0
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then ct1=1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ct2=1 end
	if ct1==0 and ct2==0 then return false end
	if chkc then return chkc:IsOnField() and c101234008.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101234008.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.SelectTarget(tp,c101234008.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if ct1==1 and ct2==1 then
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
	if ct1==1 and ct2~=1 then Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND) end
	if ct2==1 and ct1~=1 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) end
end
function c101234008.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ct1,ct2=0
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then ct1=1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ct2=1 end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if ct1==0 and ct2==0 then return end
	local att=tc:GetAttribute()
	local g=Duel.SelectMatchingCard(tp,c101234008.eqfilter,tp,LOCATION_DECK,0,1,1,nil,att)
	local g1=g:GetFirst()
	if g1 then
		local sel=0
		if ct2==1 then sel=1 end
		if ct1==1 and ct2==1 then
			sel=Duel.SelectOption(tp,aux.Stringid(101234008,0),aux.Stringid(101234008,1))
		end      
		if sel==0 then
			if g1 and Duel.Equip(tp,g1,tc) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c101234008.eqlimit)
				e1:SetLabelObject(tc)
				g1:RegisterEffect(e1)
			end      
		end
		if sel==1 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101234008.eqlimit(e,c)
	return c==e:GetLabelObject()
end