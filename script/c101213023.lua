--에스큘럼의 결연희
function c101213023.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101213023.afil1,c101213023.afil2)
	c:EnableReviveLimit()
	--효과 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101213023.efilter)
	c:RegisterEffect(e1)
	--자괴
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c101213023.descon)
	c:RegisterEffect(e2)
	--필드 무효
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetCondition(c101213023.discon)
	c:RegisterEffect(e3)
	--카드 파괴
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c101213023.condition)
	e4:SetTarget(c101213023.target)
	e4:SetOperation(c101213023.operation)
	c:RegisterEffect(e4)
end
function c101213023.afil1(c)
	return c:IsSetCard(0xef3) and c:IsType(TYPE_MONSTER)
end
function c101213023.afil2(c)
	return c:IsType(TYPE_LINK)
end
function c101213023.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c101213023.cfilter(c)
	return c:IsSetCard(0xef3) and c:IsType(TYPE_LINK)
end
function c101213023.descon(e,tp)
	local g=Duel.GetMatchingGroup(c101213023.cfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)<3
end
function c101213023.discon(e)
	local ec=e:GetHandler()
	return Duel.GetAttacker()==ec or Duel.GetAttackTarget()==ec
end
function c101213023.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetBattleDamage(1-tp)>=3000
end
function c101213023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c101213023.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,30)
	Duel.Destroy(g,REASON_EFFECT)
end