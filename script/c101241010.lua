--플러드리의 관리자
c101241010.AccessMonsterAttribute=true
function c101241010.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241010.afil1,c101241010.afil2)
	c:EnableReviveLimit()
	--전투 파괴 소재
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c101241010.bcon)
	e1:SetOperation(c101241010.bop)
	c:RegisterEffect(e1)
	--관리자 메세지
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101241010.con)
	e2:SetOperation(c101241010.thop)
	c:RegisterEffect(e2)
	--창조신족
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(RACE_CREATORGOD)
	e3:SetCondition(c101241010.rcon)
	c:RegisterEffect(e3)
	--공격력 상승
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCountLimit(1)
	e4:SetTarget(c101241010.atktg)
	e4:SetOperation(c101241010.atkop)
	c:RegisterEffect(e4)
	--배틀 페이즈 효과
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e5:SetCondition(c101241010.bpcon)
	e5:SetOperation(c101241010.posop)
	c:RegisterEffect(e5)
	--어드민 제거
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c101241010.rmcon)
	e6:SetOperation(c101241010.rmop)
	c:RegisterEffect(e6)
end
function c101241010.afil1(c,tp)
	return c:GetFlagEffect(101241010)~=0
end
function c101241010.afil2(c)
	return c:IsType(TYPE_EFFECT)
end
function c101241010.bcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	return a:IsType(TYPE_MONSTER) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c101241010.bop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsFaceup() then
		tc:RegisterFlagEffect(101241010,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c101241010.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101241010.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 타오르는 칼날의 관리자가 출몰했습니다.")
end
function c101241010.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c101241010.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc end
end
function c101241010.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
end
function c101241010.eqfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c101241010.bpcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	local tid=e:GetHandler():GetFlagEffectLabel(101241910)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and ad==nil 
		and Duel.IsExistingMatchingCard(c101241010.eqfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetTurnPlayer()==tp and not tid
end
function c101241010.posfilter(c)
	return c:IsDefensePos() or c:IsFacedown()
end
function c101241010.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101241010.posfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	e:GetHandler():RegisterEffect(e1)
end
function c101241010.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad and e:GetHandler():GetBattledGroupCount()<1
end
function c101241010.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
		c:RegisterFlagEffect(101241910,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end