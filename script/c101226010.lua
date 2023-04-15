--집중의 신살마녀
function c101226010.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101226010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,101226010)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101226010.target)
	e1:SetOperation(c101226010.operation)
	c:RegisterEffect(e1)	
end
function c101226010.spfilter(c,e,tp)
	return c:IsSetCard(0x612) and not c:IsType(TYPE_ACCESS) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101226010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101226010.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,101226013,0xf,0x4011,2500,2500,10,RACE_DIVINE,ATTRIBUTE_DIVINE,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101226010.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local token=Duel.CreateToken(tp,101226013)
	if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local g=Duel.SelectMatchingCard(tp,c101226010.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
			local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c101226010.splimit)
	Duel.RegisterEffect(e2,tp)
	end
end
function c101226010.splimit(e,c)
	return not (c:IsType(TYPE_ACCESS) and c:IsSetCard(0x612)) and c:IsLocation(LOCATION_EXTRA)
end