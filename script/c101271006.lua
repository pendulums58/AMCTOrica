--월하발도 - 달빛을 비추는 검
function c101271006.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,3,c101271006.lcheck)
	c:EnableReviveLimit()
	
	--이 카드가 공격 시에는 카드의 효과 발동 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c101271006.actcon)
	c:RegisterEffect(e1)
	
	--이 카드의 공격력을 배로 함
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c101271006.atop)
	c:RegisterEffect(e2)
	
	--1번 위치에 있으면 월하 카드 공격력을 올림
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c101271006.atkcon)
	e3:SetTarget(c101271006.atktg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	
	--2/4에 있으면 특수 소환 몹과의 전투로 파괴 안됌
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c101271006.indes)
	c:RegisterEffect(e4)
	
	--한 번 더 때림
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c101271006.eacon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	
	--전투 대미지는 배가 된다.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e6:SetCondition(c101271006.damcon)
	e6:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e6)
end
--1번 효과 구현
function c101271006.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x642)
end
function c101271006.actcon(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c or Duel.GetAttackTarget()==c
end
function c101271006.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c101271006.atktg(e,c)
	return c:IsSetCard(0x642)
end
function c101271006.atkcon(e)
	local c=e:GetHandler()
	return c:GetSequence()==0
end
function c101271006.indes(e,c)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and (c:GetSequence()==1 or c:GetSequence()==3)
end
function c101271006.eacon(e)
	local c=e:GetHandler()	 
	return c:GetSequence()==2
end
function c101271006.damcon(e)
	local c=e:GetHandler()
	return c:GetBattleTarget()~=nil and c:GetSequence()==4
end
