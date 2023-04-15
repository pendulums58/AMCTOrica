--허각의 관리자
c111310134.AmassEffect=1
function c111310134.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310134.afil1,c111310134.afil2)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310134.con)
	e1:SetOperation(c111310134.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(cyan.nacon)
	c:RegisterEffect(e2)
	--축적
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetDescription(aux.Stringid(111310134,0))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCondition(c111310134.rmcon)
	e3:SetTarget(c111310134.rmtg)
	e3:SetOperation(c111310134.rmop)
	c:RegisterEffect(e3)
	--필드 마법 세팅
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(111310134,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cyan.nacon)
	e4:SetCost(cyan.dhcost(1))
	e4:SetTarget(c111310134.tftg)
	e4:SetOperation(c111310134.tfop)
	c:RegisterEffect(e4)
	--어드민 제거
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_REMOVE)
	e5:SetCondition(c111310134.rmcon)
	e5:SetOperation(c111310134.rmop)
	c:RegisterEffect(e5)	
end
function c111310134.afil1(c)
	return c:IsLevel(3) or c:IsLevel(4)
end
function c111310134.afil2(c)
	return c:IsType(TYPE_TOKEN)
end
function c111310134.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310134.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 버림받은 자들의 우상이 강림했습니다.")
end
function c111310134.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c111310134.rmtg(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return Duel.AmassCheck(tp) end
end
function c111310134.rmop(e,tp,ep,eg,ev,re,r,rp)
	Duel.Amass(e,800)
end
function c111310134.tffilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c111310134.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c111310134.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c111310134.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c111310134.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function c111310134.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c111310134.fchk,1,nil) and rp==tp and r==REASON_EFFECT
		and e:GetHandler():GetAdmin()
end
function c111310134.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end
function c111310134.fchk(c)
	return c:GetPreviousLocation()==LOCATION_GRAVE
end