--라디언트 어센션
local s,id=GetID()
function s.initial_effect(c)
	--덱 의식
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTarget(s.target(e1))
	e2:SetCondition(s.spcon1)	
	e2:SetDescription(aux.Stringid(id,0))
	c:RegisterEffect(e2)
	--소모 없이 의식
	local e3=Ritual.CreateProc({handler=c,lvtype=RITPROC_EQUAL,filter=s.ritualfil,matfilter=s.forcedgroup,location=LOCATION_HAND})
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCondition(cyan.selfpubcon)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(0)
	e3:SetRange(LOCATION_HAND)
	c:RegisterEffect(e3)	
end
s.listed_names={101219004}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,101219004)
		and not e:GetHandler():IsPublic()
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,101219004)
		and e:GetHandler():IsPublic()
end
function s.cfilter(c,ft,tp)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil,ft,tp) 
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
		and c:IsSetCard(SETCARD_RADIANT)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)	
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil,ft,tp)
	if Duel.Release(g,REASON_COST)~=0 then
		local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.target(eff)
	local tg = eff:GetTarget()
	return function(e,...)
		local ret = tg(e,...)
		if ret then return ret end
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			Duel.SetChainLimit(s.chlimit)
		end
	end
end
function s.ritualfil(c)
	return c:IsSetCard(SETCARD_RADIANT)
end
function s.forcedgroup(c,e,tp)
	return c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end