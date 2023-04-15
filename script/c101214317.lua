--LRM(레벨 레볼루션 매직) - 스타 어크로스
function c101214317.initial_effect(c)
	--LRM
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101214317.target)
	e1:SetOperation(c101214317.activate)
	c:RegisterEffect(e1)	
	--묘지
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(aux.exccon)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101214317.target1)
	e2:SetOperation(c101214317.activate1)
	c:RegisterEffect(e2)
end
function c101214317.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xef5) and c:IsType(TYPE_SYNCHRO)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and Duel.IsExistingMatchingCard(c101214317.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c)
end
function c101214317.filter2(c,e,tp,mc,tc)
	return (c:IsLevel(tc:GetLevel()+3) or c:IsLevel(tc:GetOriginalLevel()+3))
		and c:IsSetCard(0xef5) and mc:IsCanBeSynchroMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c101214317.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101214317.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c101214317.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101214317.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101214317.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101214317.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_SYNCHRO,tp,tp,0)
		Duel.RaiseEvent(tc,EVENT_BE_MATERIAL,e,REASON_SYNCHRO,tp,tp,0)
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c101214317.filter11(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xef5) and c:IsType(TYPE_SYNCHRO)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and Duel.IsExistingMatchingCard(c101214317.filter21,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c)
end
function c101214317.filter21(c,e,tp,mc,tc)
	return (c:IsLevel(tc:GetLevel()+2) or c:IsLevel(tc:GetOriginalLevel()+2))
		and c:IsSetCard(0xef5) and mc:IsCanBeSynchroMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c101214317.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101214317.filter11(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c101214317.filter11,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101214317.filter11,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101214317.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101214317.filter21,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_SYNCHRO,tp,tp,0)
		Duel.RaiseEvent(tc,EVENT_BE_MATERIAL,e,REASON_SYNCHRO,tp,tp,0)
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end