--R-PINE 스노우 블레이드
function c111338006.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c111338006.sfilter1),aux.NonTuner(c111338006.sfilter2),1)	
	--소환된 턴 체인 불가
	--무효화
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111338006,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,111338006)	
	e1:SetCondition(c111338006.negcon)
	e1:SetCost(c111338006.negcost)
	e1:SetTarget(c111338006.negtg)
	e1:SetOperation(c111338006.negop)
	c:RegisterEffect(e1)	
	--전투 이외의 방법으로 필드에서 벗어났을 경우
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111338006,1))
	e2:SetCountLimit(1,111338506)		
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)	
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)	
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c111338006.sumcon)
	e2:SetTarget(c111338006.sumtg)
	e2:SetOperation(c111338006.sumop)
	c:RegisterEffect(e2)	
end
c111338006.material_type=TYPE_SYNCHRO
function c111338006.sfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO)
end
function c111338006.sfilter2(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO)
end
--무효화
function c111338006.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and Duel.IsChainNegatable(ev)
end
function c111338006.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsFaceup())
end
function c111338006.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(c111338006.costfilter,nil,tp)
	if chk==0 then return #g1>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g1:Select(tp,1,1,nil)
	local tc=rg:GetFirst()
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		aux.UseExtraReleaseCount(rg,tp)
		Duel.Release(tc,REASON_COST)
	end
end
function c111338006.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetTurnID()==Duel.GetTurnCount()
		then Duel.SetChainLimit(c111338006.chainlm)	
	end
end
function c111338006.chainlm(e,ep,tp)
	return tp==ep
end
function c111338006.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--벗어났을 경우
function c111338006.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) 
	and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
	and e:GetHandler():IsPreviousControler(tp)
	and not e:GetHandler():IsReason(REASON_BATTLE)
end
function c111338006.spfilter(c,e,tp)
	return c:IsSetCard(0x656) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c111338006.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c111338006.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c111338006.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c111338006.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end