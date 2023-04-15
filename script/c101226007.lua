--신살마녀 암네시아
c101226007.AccessMonsterAttribute=true
function c101226007.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101226007.afil1,c101226007.afil2)
	c:EnableReviveLimit()
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101226007)
	e1:SetCondition(c101226007.con)
	e1:SetTarget(c101226007.thtg)
	e1:SetOperation(c101226007.thop)
	c:RegisterEffect(e1)
	--공격, 효과 발동 제한
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c101226007.limtg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
	--공격력 변화
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101226007,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c101226007.poscon)
	e4:SetOperation(c101226007.datop)
	c:RegisterEffect(e4)
end
function c101226007.afil1(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c101226007.afil2(c)
	return c:IsSetCard(0x612) and c:IsType(TYPE_ACCESS)
end
function c101226007.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ACCESS
end
function c101226007.desfilter(c)
	return c:IsFaceup()
end
function c101226007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101226007.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c101226007.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	local tc=tg:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetAttack())
end
function c101226007.attfilter(c,atk)
	return c:GetAttack()>atk
end
function c101226007.limtg(e,c)
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(c101226007.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c101226007.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101226007.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		local tc=tg:GetFirst()
		local atk=tc:GetAttack()
		Duel.Damage(1-tp,atk/2,REASON_EFFECT)
	end
end
function c101226007.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetAdmin()
end
function c101226007.datop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetAdmin() then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAdmin():GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end