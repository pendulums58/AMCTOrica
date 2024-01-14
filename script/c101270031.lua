--인연날개 - 엘더브리즈
local s,id=GetID()
function s.initial_effect(c)
	--공격력
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--공격력
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(s.atkcon)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)	
end
function s.atkcon(e)
	s[0]=false
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function s.atkval(e,c)
	local d=Duel.GetAttackTarget()
	if s[0] or d:GetFlagEffect(id)>0 then
		s[0]=true
		return 3000
	else return 0 end
end
