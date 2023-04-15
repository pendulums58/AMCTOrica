--적파색의 예언자 케플러
function c112100005.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c112100005.matfilter,1,1)
	--특소
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112100005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c112100005.target)
	e1:SetOperation(c112100005.operation)
	c:RegisterEffect(e1)
end
function c112100005.matfilter(c,lc,sumtype,tp)
	return c:GetLevel()==1 and not c:IsType(TYPE_TOKEN,lc,sumtype,tp)
end 
function c112100005.filter(c,e,tp,zone)
	return c:IsSetCard(0x65b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c112100005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c112100005.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c112100005.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112100005.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	--소환 제한
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(112100005,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c112100005.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)		
end
function c112100005.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not (c:IsLevel(1) or c:IsRank(1) or c:IsLink(1))
end