--단델리온의 관리자
c101241005.AccessMonsterAttribute=true
function c101241005.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241005.afil,c101241005.afil)
	c:EnableReviveLimit()
	--액세스 제한
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(CYAN_EFFECT_CANNOT_BE_ACCESS_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c101241005.acclimit)
	c:RegisterEffect(e1)
	--관리자 메세지
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101241005.con)
	e2:SetOperation(c101241005.thop)
	c:RegisterEffect(e2)
	--창조신족
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(RACE_CREATORGOD)
	e3:SetCondition(c101241005.rcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetValue(12)
	c:RegisterEffect(e4)
	--프로시저 특소
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCondition(c101241005.spcon)
	e5:SetTarget(c101241005.sptg)
	e5:SetOperation(c101241005.spop)
	c:RegisterEffect(e5)
	--어드민 제거
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c101241005.rmcon)
	e6:SetCost(c101241005.cost)
	e6:SetOperation(c101241005.rmop)
	c:RegisterEffect(e6)
	
end
function c101241005.afil(c)
	return c:IsType(TYPE_EFFECT)
end
function c101241005.acclimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x605)
end
function c101241005.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101241005.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 불어오는 신탁의 관리자가 내려앉았습니다.")
end
function c101241005.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c101241005.spcon(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():GetSummonType()==SUMMON_TYPE_ACCESS
end
function c101241005.spfilter(c,e,tp)
	return c:IsCode(111310014) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101241005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101241005.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101241005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101241005.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101241005.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad
end
function c101241005.cfilter2(c)
	return c:IsType(TYPE_ACCESS) and c:IsAbleToDeckAsCost()
end
function c101241005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101241005.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c101241005.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c101241005.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end