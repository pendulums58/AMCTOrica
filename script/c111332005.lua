--미스트레이퍼 래디언트
function c111332005.initial_effect(c)
--특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111332005)
	e1:SetCost(c111332005.cost)
	e1:SetTarget(c111332005.target)
	e1:SetOperation(c111332005.activate)
	c:RegisterEffect(e1)
--대신 파괴	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,111332505)	
	e2:SetTarget(c111332005.reptg)
	e2:SetValue(c111332005.repval)
	e2:SetOperation(c111332005.repop)
	c:RegisterEffect(e2)	
end
--특소
function c111332005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c111332005.cfilter(c,e,tp)
	return c:IsSetCard(0x643) and Duel.IsExistingMatchingCard(c111332005.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
		and Duel.GetMZoneCount(tp,c)>0
end
function c111332005.spfilter(c,e,tp,code)
	return not c:IsCode(code) and c:IsSetCard(0x643) and c:IsType(TYPE_MONSTER) and c:IsLevel(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function c111332005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c111332005.cfilter,tp,0,LOCATION_MZONE,1,nil,e,tp)
		or Duel.CheckReleaseGroup(tp,c111332005.cfilter,1,nil,e,tp) 
	end
	local g=Duel.GetReleaseGroup(tp):Filter(c111332005.cfilter,nil,e,tp)
	local g1=Duel.GetMatchingGroup(c111332005.cfilter,tp,0,LOCATION_MZONE,nil,e,tp)
	g:Merge(g1)
	local tc=g:Select(tp,1,1,nil)
	Duel.SetTargetParam(tc:GetFirst():GetCode())
	Duel.Release(tc,REASON_COST)	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c111332005.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c111332005.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
--대신 파괴
function c111332005.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x643) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp)
end
function c111332005.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c111332005.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c111332005.repval(e,c)
	return c111332005.repfilter(c,e:GetHandlerPlayer())
end
function c111332005.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end