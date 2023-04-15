--인화의 관리자
function c111310123.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310123.afil1,c111310123.afil2)
	c:EnableReviveLimit()		
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310123.con1)
	e1:SetOperation(c111310123.thop1)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(cyan.nacon)
	c:RegisterEffect(e2)
	--데미지 2배
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e3)
	--데미지 2배 - 어드민 없을 시
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cyan.nacon)
	e4:SetValue(c111310123.damval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cyan.nacon)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	e5:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e5)	
	--어드민 덤핑
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(111310123,3))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetCondition(c111310123.tdcon)
	e6:SetOperation(c111310123.rmop)
	c:RegisterEffect(e6)
end
function c111310123.afil1(c)
	return c:IsLevelAbove(9)
end
function c111310123.afil2(c)
	return c:IsType(TYPE_ACCESS)
end
function c111310123.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310123.thop1(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 인간의 불씨로 탄생한 관리자가 하계했습니다.")
end
function c111310123.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if bit.band(r,REASON_EFFECT)==0 then return val end
	return val*2
end
function c111310123.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad~=nil and tp~=Duel.GetTurnPlayer()
end
function c111310123.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end