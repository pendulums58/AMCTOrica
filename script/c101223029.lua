--샐비지 핸드-리부트
function c101223029.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c101223029.sptg)
	e1:SetOperation(c101223029.spop)
	c:RegisterEffect(e1)	
	--필드를 벗어난 경우에 특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c101223029.spcon)
	e2:SetTarget(c101223029.sptg1)
	e2:SetOperation(c101223029.spop1)
	c:RegisterEffect(e2)	
end
function c101223029.filter(c,e,tp,tid)
	return bit.band(c:GetReason(),REASON_EFFECT)~=0 and c:GetReasonPlayer()==1-tp
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223029.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101223029.filter(chkc,e,tp,tid) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101223029.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101223029.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tid)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101223029.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101223029.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT)
end
function c101223029.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223029.cfilter,1,nil) and rp==1-tp
end
function c101223029.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c101223029.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(c101223029.spfilter,1,nil,e,tp) end
	local tc=eg:GetFirst()
	while tc do
		tc:CreateEffectRelation(e)
		tc=eg:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101223029.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=eg:FilterSelect(tp,c101223029.spfilter,1,1,nil,e,tp):GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 
		and Duel.GetTurnCount()~=e:GetHandler():GetTurnID() then
			Duel.Draw(tp,1,REASON_EFFECT)
	end
end