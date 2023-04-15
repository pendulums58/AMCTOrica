--지성의 창성체 엔비오스
function c101248003.initial_effect(c)
	--자체 특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101248003)
	e1:SetCost(c101248003.spcost)
	e1:SetTarget(c101248003.sptg)
	e1:SetOperation(c101248003.spop)
	c:RegisterEffect(e1)
	--묘지 직시자 특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101248003)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101248003.target1)
	e2:SetOperation(c101248003.operation1)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101248003,ACTIVITY_SPSUMMON,c101248003.counterfilter)
end
function c101248003.counterfilter(c)
	return (c:GetSummonLocation()~=LOCATION_HAND and c:GetSummonLocation()~=LOCATION_DECK) or c:GetLevel()==11
end
function c101248003.cfilter(c)
	return c:GetLevel()==11 and c:IsAbleToGraveAsCost()
end
function c101248003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101248003.cfilter,tp,LOCATION_DECK,0,1,nil)
		and  Duel.GetCustomActivityCount(101248003,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101248003.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101248003.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101248003.splimit(e,c)
	return c:IsLocation(LOCATION_GRAVE+LOCATION_DECK) and not c:GetLevel()==11
end
function c101248003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101248003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101248003.filter1(c,e,tp)
	return c:GetLevel()==11 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101248003.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101248003.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101248003.filter1,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101248003.filter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101248003.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end