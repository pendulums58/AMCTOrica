--스카이워커 트로포스피어
function c101214310.initial_effect(c)
	c:SetSPSummonOnce(101214310)	
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c101214310.synfilter1),1)
	c:EnableReviveLimit()
	--특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cyan.SynSSCon)
	e1:SetCost(c101214310.spcost)
	e1:SetTarget(c101214310.sptg)
	e1:SetOperation(c101214310.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101214310,ACTIVITY_SPSUMMON,c101214310.counterfilter)
end
function c101214310.synfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c101214310.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_SYNCHRO) or c:IsSetCard(0xef5)
end
function c101214310.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101214310,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101214310.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)	
end
function c101214310.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_SYNCHRO) or c:IsSetCard(0xef5)) and c:IsLocation(LOCATION_EXTRA)
end
function c101214310.tgfilter(c,e,tp)
	return c:IsSetCard(0xef5) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
		and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c101214310.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c101214310.spfilter(c,e,tp,tc)
	return c:IsSetCard(0xef5) and c:IsLevel(tc:GetLevel()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsCode(tc:GetCode())
end
function c101214310.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end
	if chkc then return mg:IsContains(chkc) and c101214310.tgfilter(chkc,e,tp) end
	if chk==0 then return mg:IsExists(c101214310.tgfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=mg:FilterSelect(tp,c101214310.tgfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c101214310.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c101214310.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end