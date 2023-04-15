--흑백의 교차
function c101225010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101225010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetCountLimit(1,101225010)
	e1:SetTarget(c101225010.target)
	e1:SetOperation(c101225010.activate)
	c:RegisterEffect(e1)	
end
function c101225010.filter(c,e,tp)
	return c:IsSetCard(0x60b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101225010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc,exc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101225010.filter,tp,LOCATION_HAND,0,1,exc,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101225010.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101225010.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()	
		if g:GetCount()>0 
		and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 	
		and tc:IsType(TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c101225010.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then 
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(101225010,0)) then 	
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101225010.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				if g1:GetCount()>0 then
				Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c101225010.spfilter(c,e,tp)
	return c:IsSetCard(0x60b) 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	and not c:IsType(TYPE_TUNER)
end