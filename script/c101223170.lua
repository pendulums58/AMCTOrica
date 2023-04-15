--정수의 화신
function c101223170.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--퇴화빔
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cyan.SynSSCon)
	e1:SetTarget(c101223170.dvtg)
	e1:SetOperation(c101223170.dvop)
	c:RegisterEffect(e1)
	--공격력 상승
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(800)
	c:RegisterEffect(e2)	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function c101223170.dvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,tp,LOCATION_GRAVE)
end
function c101223170.dvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local g1=Duel.GetOperatedGroup()
		local sg=Group.CreateGroup()
		local tc=g1:GetFirst()
		while tc do
			local g2=Duel.GetMatchingGroup(c101223170.dvfilter,tp,0,LOCATION_GRAVE,nil,e,tp,tc)
			if g2:GetCount()>0 then
				g2=g2:RandomSelect(tp,1)
				sg:Merge(g2)
			end
			tc=g1:GetNext()
		end
		local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if sg:GetCount()>ft then
			sg=sg:Select(1-tp,ft,ft,nil)
		end
		Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
function c101223170.dvfilter(c,e,tp,tc)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	if tc:IsType(TYPE_LINK) then
		return c:IsType(TYPE_LINK) and c:IsLink(tc:GetLink()-1)
	end
	if tc:IsType(TYPE_XYZ) then
		return c:IsType(TYPE_XYZ) and c:IsRank(tc:GetRank()-1)
	end	
	return c:IsLevel(tc:GetLevel()-1)
end