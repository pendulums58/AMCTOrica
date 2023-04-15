--머메이드 도미네이터
c111310019.AccessMonsterAttribute=true
function c111310019.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310019.afil1,c111310019.afil2)
	c:EnableReviveLimit()
	--공뻥
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c111310019.con)
	e1:SetCost(c111310019.adcost)
	e1:SetCountLimit(1,111310019)
	e1:SetTarget(c111310019.adtg)
	e1:SetOperation(c111310019.adop)
	c:RegisterEffect(e1)
	--특소
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310019,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c111310019.thcon)
	e2:SetTarget(c111310019.sptg)
	e2:SetCountLimit(1,111311019)
	e2:SetOperation(c111310019.spop)
	c:RegisterEffect(e2)
end
function c111310019.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310019.afil1(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c111310019.afil2(c)
	return c:IsRace(RACE_AQUA+RACE_FISH+RACE_SEASERPENT)
end
function c111310019.cfilter(c,rc,att)
	return c:GetLevel()>=4 and c:IsRace(rc) and c:IsAttribute(att)
end
function c111310019.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ad=e:GetHandler():GetAdmin()
	if not ad then return false end
	local rc=ad:GetRace()
	local att=ad:GetAttribute()
	if chk==0 then return Duel.IsExistingMatchingCard(c111310019.cfilter,tp,LOCATION_DECK,0,1,nil,rc,att) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c111310019.cfilter,tp,LOCATION_DECK,0,1,1,nil,rc,att)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabel(tc:GetAttack())
end
function c111310019.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c111310019.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310019.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c111310019.adop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c111310019.filter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(e:GetLabel())
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c111310019.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c111310019.filter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:GetLevel()<=4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c111310019.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c111310019.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c111310019.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c111310019.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c111310019.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end