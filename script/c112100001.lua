--청의 파색 올베르스
function c112100001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112100001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,112100001)
	e1:SetCondition(c112100001.spcon)
	e1:SetTarget(c112100001.sptg)
	e1:SetOperation(c112100001.spop)
	c:RegisterEffect(e1)	
end
function c112100001.bravecon(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c112100001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or c112100001.bravecon(e))
end
function c112100001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c112100001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	--소환 제한
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(112100001,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c112100001.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)		
end
function c112100001.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not (c:IsLevel(1) or c:IsRank(1) or c:IsLink(1))
end