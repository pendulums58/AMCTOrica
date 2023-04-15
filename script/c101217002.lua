--RUM(랭크 업 매직)-에고 어웨이크닝
function c101217002.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101217002.sumcon)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101217002.adtg)
	e1:SetOperation(c101217002.activate)
	c:RegisterEffect(e1)
end
function c101217002.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xef7) and c:IsType(TYPE_XYZ)
end
function c101217002.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101217002.cfilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=4
end
function c101217002.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101217002.filter(e,tp,chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101217002.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101217002.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101217002.filter(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c)>0 and (rk>0 or c:IsStatus(STATUS_NO_LEVEL))
	and Duel.IsExistingMatchingCard(c101217002.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+6)
end
function c101217002.filter2(c,e,tp,mc,rk)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp)
	and c:IsRank(rk) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)	and c:IsSetCard(0xef7)
	and mc:IsCanBeXyzMaterial(c,tp)
end
function c101217002.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101217002.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+6)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
	local dc=Duel.GetMatchingGroup(c101217002.rmfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	Duel.Remove(dc,POS_FACEUP,REASON_EFFECT)
end
function c101217002.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_XYZ)
end