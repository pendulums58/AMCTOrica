--백그라운드 페인터
c111310050.AccessMonsterAttribute=true
function c111310050.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310050.afil1,c111310050.afil2)
	c:EnableReviveLimit()
	--파ㅚ될 경우
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c111310050.repcon)
	e1:SetOperation(c111310050.repop)
	c:RegisterEffect(e1)
	--액세스 레벨
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(CYAN_EFFECT_ACCESS_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c111310050.indtg)
	e2:SetValue(c111310050.slevel)
	c:RegisterEffect(e2)
	--특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(111310050,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c111310050.sptarget)
	e3:SetOperation(c111310050.spoperation)
	c:RegisterEffect(e3)
end
function c111310050.afil1(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and bit.band(c:GetSummonLocation(),LOCATION_GRAVE)~=0
end
function c111310050.afil2(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0
end
function c111310050.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c111310050.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function c111310050.indtg(e,c)
	return not c:IsType(TYPE_ACCESS)
end
function c111310050.slevel(e,c,acc)
	if c:GetLevel()<=0 then return 0 end
	return c:GetLevel()+2
end
function c111310050.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c111310050.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c111310050.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c111310050.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c111310050.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end