--라디언트 어센션
local s,id=GetID()
function s.initial_effect(c)
	--특수 소환(비공개 상태)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetCondition(s.npcon)
	e1:SetTarget(s.sptg)
	c:RegisterEffect(e1)
	--특수 소환(공개 상태)
	local e2=e1:Clone()
	e2:SetCondition(s.pubcon)
	e2:SetTarget(s.sptg1)
	c:RegisterEffect(e2)
end
s.listed_names={101219004}
function s.npcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic()
end
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function s.cfilter(c,e,tp)
	local loc=LOCATION_HAND
	if c:IsCode(101219004) then loc=loc+LOCATION_DECK end
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,loc,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,tc)
	return (c:IsLevel(tc:GetLevel()) or c:IsLevel(tc:GetLevel()*2))
		and c:IsType(TYPE_RITUAL) and c:IsSetCard(SETCARD_RADIANT) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local loc=LOCATION_HAND
	if e:GetLabelObject():IsCode(101219004) then loc=loc+LOCATION_DECK end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local loc=LOCATION_HAND
	if e:GetLabelObject():IsCode(101219004) then loc=loc+LOCATION_DECK end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(s.chainlimit)
	end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then return end
	local tc=e:GetLabelObject()
	local loc=LOCATION_HAND
	if tc:IsCode(101219004) then loc=loc+LOCATION_DECK end	
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,loc,0,1,1,nil,e,tp,tc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
	end
end
function s.chainlimit(e,rp,tp)
	return not e:IsActiveType(TYPE_MONSTER)
end