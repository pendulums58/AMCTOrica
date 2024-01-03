--최후의 음색
c101270007.AmassEffect=true
function c101270007.initial_effect(c)
	--슈퍼 축적
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101270007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101270007.amtg)
	e1:SetOperation(c101270007.amop)
	c:RegisterEffect(e1)
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c101270007.spcon)
	e2:SetCost(c101270007.cost)
	e2:SetTarget(c101270007.sptg)
	e2:SetOperation(c101270007.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101270007,ACTIVITY_SPSUMMON,c101270007.counterfilter)
end
function c101270007.counterfilter(c)
	return true
end
function c101270007.amtg(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return Duel.AmassCheck(tp) end
end
function c101270007.amop(e,tp,ep,eg,ev,re,r,rp)
	Duel.Amass(e,1000)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,101270001) then
		Duel.Amass(e,1000)
	end
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,101270003) then
		Duel.Amass(e,1000)
	end
end
function c101270007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101270007.chk,1,nil)
end
function c101270007.chk(c)
	return c:IsReason(REASON_BATTLE) and c:IsType(TYPE_TOKEN)
end
function c101270007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101270007,tp,ACTIVITY_SPSUMMON)==0
		and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101270007.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101270007.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not e==se
end
function c101270007.spfilter(c,e,tp)
	return c:IsCode(101270001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101270007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101270007.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101270007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101270007.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end