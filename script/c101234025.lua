--여환무장 -파멸-
function c101234025.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c101234025.cost)
	e1:SetTarget(c101234025.target)
	e1:SetOperation(c101234025.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101234025,ACTIVITY_SPSUMMON,c101234025.counterfilter)
end
function c101234025.counterfilter(c)
	return c:IsSetCard(0x611)
end
function c101234025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101234025,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c101234025.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101234025.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x611)
end
function c101234025.filter1(c,e,tp)
	local att=c:GetAttribute()
	return c:IsFaceup() and c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c101234025.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,att)
end
function c101234025.filter2(c,e,tp,mc,att)
	return c:GetAttribute()==att and c:IsSetCard(0x611) and mc:IsCanBePairingMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PAIRING,tp,false,false) and c:IsType(TYPE_PAIRING)
end
function c101234025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101234025.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c101234025.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101234025.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101234025.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101234025.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetAttribute())
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_PAIRING)
		Duel.SpecialSummon(sc,SUMMON_TYPE_PAIRING,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end