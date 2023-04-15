--시스투스의 관리자
c101241009.AccessMonsterAttribute=true
function c101241009.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241009.afil1,c101241009.afil2)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101241009.con)
	e1:SetOperation(c101241009.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(c101241009.rcon)
	c:RegisterEffect(e2)
	--토큰
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(c101241009.sptg)
	e3:SetOperation(c101241009.spop)
	c:RegisterEffect(e3)
	--필드클린
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_ADJUST)
	e4:SetCost(c101241009.dcost)
	e4:SetCondition(c101241009.dcon)
	e4:SetTarget(c101241009.dtg)
	e4:SetOperation(c101241009.dop)
	c:RegisterEffect(e4)
	--어드민 제거
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c101241009.rmcon)
	e5:SetOperation(c101241009.rmop)
	c:RegisterEffect(e5)
end
function c101241009.afil1(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(3) and c:IsAttackAbove(1500)
end
function c101241009.afil2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x605)
end
function c101241009.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101241009.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 화려한 소망의 관리자의 흔적을 발견했습니다.")
end
function c101241009.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c101241009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c101241009.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,101241021,0,0,1500,1500,3,RACE_PLANT,ATTRIBUTE_WATER) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,101241021)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_ACCESS_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c101241009.xyzlimit)
		token:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
function c101241009.xyzlimit(e,c)
	return not c:IsCode(101241009)
end
function c101241009.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(101241009)==0 end
	c:RegisterFlagEffect(101241009,RESET_CHAIN,0,1)
end
function c101241009.dcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAdmin()==nil and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,6,nil)
end
function c101241009.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101241009.dop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c101241009.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad
end
function c101241009.cfilter2(c)
	return c:IsType(TYPE_ACCESS) and c:IsAbleToDeckAsCost()
end
function c101241009.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101241009.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101241009.splimit(e,c)
	return (c:IsSetCard(0x605) and not c:IsCode(101241009))
end