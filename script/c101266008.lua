--유니에이트 포어텔
function c101266008.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101266008,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101266008)
	e1:SetCondition(c101266008.spcon)
	e1:SetTarget(c101266008.sptg)
	e1:SetOperation(c101266008.spop)
	c:RegisterEffect(e1)
	--바운스
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c101266008.con)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	cyan.JustSearch(e2,LOCATION_GRAVE+LOCATION_MZONE,Card.IsType,TYPE_MONSTER,Card.IsSetCard,0x634)
	c:RegisterEffect(e2)
end
function c101266008.spfilter(c,e,tp)
	return c:IsSetCard(0x634) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101266008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c101266008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101266008.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,ct,nil,e,tp) end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<2 then
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	else
		e:SetProperty(0)
	end	
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<2 then
		Duel.SetChainLimit(c101266008.chainlm)	
	end
end
function c101266008.chainlm(e,rp,tp)
	return tp==rp
end
function c101266008.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(c101266008.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<1 or ct<1 or g:GetCount()<ct then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,ct,ct,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c101266008.con(e,tp,eg,ep,ev,re,r,rp)
	return 1-tp==Duel.GetTurnPlayer()
end