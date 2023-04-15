--업혼의 관리자
c111310064.AccessMonsterAttribute=true
function c111310064.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310064.afil1,c111310064.afil1)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310064.con)
	e1:SetOperation(c111310064.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(cyan.nacon)
	c:RegisterEffect(e2)
	--제외 불가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	c:RegisterEffect(e3)
	--특수 소환 제약
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetTarget(c111310064.sumlimit)
	c:RegisterEffect(e4)
	--어드민 제거
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c111310064.rmcon)
	e5:SetOperation(c111310064.rmop)
	c:RegisterEffect(e5)
end
function c111310064.afil1(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and bit.band(c:GetSummonLocation(),LOCATION_GRAVE)~=0
end
function c111310064.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310064.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 죄를 불태우는 관리자가 현계했습니다.")
end
function c111310064.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_GRAVE)
end
function c111310064.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=e:GetHandler():GetAdmin()
	return ad and not Duel.IsExistingMatchingCard(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c111310064.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end