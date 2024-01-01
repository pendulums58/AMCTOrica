--구원하는 신비
local s,id=GetID()
function s.initial_effect(c)
	--신비 공통 효과
	cyan.AddHaloEffect(c,TYPE_EFFECT)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCost(cyan.selftgcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE)
		and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local tc=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		local zone=0x1f
		for tc1 in aux.Next(g) do
			zone=zone&(~tc1:GetColumnZone(LOCATION_MZONE,0,0,tp))
		end			
		if zone>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end
function s.spfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local zone=0x1f
	for tc in aux.Next(g) do
		zone=zone&(~tc:GetColumnZone(LOCATION_MZONE,0,0,tp))
	end	
	return c:IsSetCard(SETCARD_MYSTERY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and not c:IsCode(id)
end