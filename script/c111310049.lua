--스타 페인터
c111310049.AccessMonsterAttribute=true
function c111310049.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310049.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--패특소
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310049,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,111310049)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c111310049.hspcon)
	e1:SetTarget(c111310049.hsptg)
	e1:SetOperation(c111310049.hspop)
	c:RegisterEffect(e1)
	--종족 변경
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c111310049.attr)
	c:RegisterEffect(e2)
	--묘지 소생
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111310049,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,111310149)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCost(c111310049.cost)
	e3:SetCondition(c111310049.spcon)
	e3:SetTarget(c111310049.sptg)
	e3:SetOperation(c111310049.spop)
	c:RegisterEffect(e3)	
end
function c111310049.afil1(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and bit.band(c:GetSummonLocation(),LOCATION_HAND)~=0
end
function c111310049.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310049.hspfilter(c,e,tp,race)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsRace(race)
end
function c111310049.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c111310049.hspfilter,tp,LOCATION_HAND,0,1,nil,e,tp,e:GetHandler():GetRace()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c111310049.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c111310049.hspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,e:GetHandler():GetRace())
	local tc=g:GetFirst()
	if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
function c111310049.attr(e)
	local ad=e:GetHandler():GetAdmin()
	if not ad then return 0 end
	return ad:GetRace()
end
function c111310049.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310049.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c111310049.cfilter,1,nil,tp)
end
function c111310049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c111310049.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c111310049.dhfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c111310049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310049.dhfilter,tp,LOCATION_HAND,0,1,nil) end
		Duel.DiscardHand(tp,c111310049.dhfilter,1,1,REASON_COST)
end
