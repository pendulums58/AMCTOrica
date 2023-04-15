--TCP 싱커
c111310006.AccessMonsterAttribute=true
function c111310006.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310006.afil1,c111310006.afil2)
	c:EnableReviveLimit()
	--묘지 소생
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,111310006)
	e1:SetCondition(c111310006.condition)
	e1:SetTarget(c111310006.sptg)
	e1:SetOperation(c111310006.spop)
	c:RegisterEffect(e1)
	--효과 발동 제한
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c111310006.aclimit)
	c:RegisterEffect(e2)
end
function c111310006.afil1(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and bit.band(c:GetSummonLocation(),LOCATION_GRAVE)~=0
end
function c111310006.afil2(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and bit.band(c:GetSummonLocation(),LOCATION_DECK+LOCATION_HAND)~=0
end
function c111310006.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310006.filter(c,e,tp,att)
	return c:GetAttack()<=1500 and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c111310006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ad=e:GetHandler():GetAdmin()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c111310006.filter(chkc,e,tp,ad:GetAttribute()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c111310006.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ad:GetAttribute()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c111310006.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ad:GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c111310006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		c:SetCardTarget(tc)
	end
end
function c111310006.aclimit(e,re,tp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if not tc then return false end
	local lv=tc:GetLevel()
	if tc:IsType(TYPE_XYZ) then lv=tc:GetRank() end
	local eh=re:GetHandler()
	local rlv=eh:GetLevel()
	if eh:IsType(TYPE_XYZ) then rlv=eh:GetRank() end	
	return re:IsActiveType(TYPE_MONSTER) and (lv>rlv or eh:IsType(TYPE_LINK))
end
