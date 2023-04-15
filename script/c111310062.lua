--청접의 관리자
c111310062.AccessMonsterAttribute=true
function c111310062.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310062.con)
	e1:SetOperation(c111310062.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(cyan.nacon)
	c:RegisterEffect(e2)
	--전투 파괴
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111310062,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetTarget(c111310062.destg)
	e3:SetOperation(c111310062.desop)
	c:RegisterEffect(e3)
	--공격력을 0으로
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(c111310062.accon)
	e4:SetTarget(c111310062.atktg)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	--효과 무효
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(c111310062.accon)
	e5:SetTarget(c111310062.atktg)
	e5:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e5)
	--어드민 제거
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(111310062,0))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(aux.bdocon)
	e6:SetOperation(c111310062.rmop)
	c:RegisterEffect(e6)
end
function c111310062.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310062.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 푸른 환혹의 관리자가 접속했습니다.")
end
function c111310062.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and tc:IsAttribute(0x77) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c111310062.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
function c111310062.accon(e)
	local ad=e:GetHandler():GetAdmin()
	return ad==nil
end
function c111310062.atktg(e,c)
	local tp=e:GetHandlerPlayer()
	local ak=Duel.GetAttacker()
	if ak and  ak:GetControler()==tp then ak=Duel.GetAttackTarget() end
	if ak then return c==ak end
	return false
end
function c111310062.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end