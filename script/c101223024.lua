--사룡의 사역자
function c101223024.initial_effect(c)
	c:SetSPSummonOnce(101223024)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223014.pfilter,c101223014.mfilter,1,1)
	c:EnableReviveLimit()
	--어드민으로 사용 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(CYAN_EFFECT_CANNOT_BE_ADMIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--엑시즈 소재 불가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--특소 후 페어로 만들기
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c101223014.cost)
	e4:SetTarget(c101223014.target)
	e4:SetOperation(c101223014.operation)
	c:RegisterEffect(e4)
end
function c101223014.pfilter(c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_DRAGON)
end
function c101223014.mfilter(c,pair)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()==pair:GetLevel()
end
function c101223024.costfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
end
function c101223024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223024.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101223024.costfilter,1,1,REASON_COST)
end
function c101223024.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:GetLevel()<=4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101223024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101223024.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101223024.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101223024.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		e:GetHandler():SetPair(g)	
	end
end