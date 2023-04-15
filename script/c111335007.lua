--빛이 사라진 순간
function c111335007.initial_effect(c)
--덱 특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111335007)
	e1:SetCost(c111335007.cost)
	e1:SetTarget(c111335007.target)
	e1:SetOperation(c111335007.activate)
	c:RegisterEffect(e1)	
--필드 파괴
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111335007,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)	
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)		
	e2:SetCountLimit(1,111335507)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)	
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c111335007.con)
	e2:SetTarget(c111335007.tg)
	e2:SetOperation(c111335007.op)
	c:RegisterEffect(e2)	
end
c111335007.remove_counter=0x326  
--덱 특소
function c111335007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x326,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x326,1,REASON_COST)
end
function c111335007.filter(c,e,tp)
	return c:IsSetCard(0x652) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_WARRIOR)
end
function c111335007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c111335007.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c111335007.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c111335007.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c111335007.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c111335007.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x652) and c:IsLocation(LOCATION_EXTRA)
end
--필드 파괴
function c111335007.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x652) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c111335007.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c111335007.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c111335007.filter2(c)
	return c:IsType(TYPE_FIELD)
end
function c111335007.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c111335007.filter2(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c111335007.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c111335007.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c111335007.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end