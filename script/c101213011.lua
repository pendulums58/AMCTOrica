--평온의 결연희
function c101213011.initial_effect(c)
	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2,2)
	c:EnableReviveLimit()
	
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101213011.con)
	e1:SetOperation(c101213011.op)
	c:RegisterEffect(e1)
	
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetCountLimit(1,101213011)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101213011.con2)
	e2:SetOperation(c101213011.op2)
	c:RegisterEffect(e2)
end
function c101213011.con(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetMutualLinkedGroup()
	local tc=eg:GetFirst()
	return ep~=tp and lg:IsContains(tc) and tc:GetBattleTarget()~=nil and tc:IsCode(101213012)
end
function c101213011.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101213011.actlimit)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end
function c101213011.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c101213011.con2(e,tp,eg,ep,ev,re,r,rp)
	local ic=e:GetHandler():GetLinkedGroup()
	return ic:IsExists(Card.IsSetCard,1,nil,0xef3) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainDisablable(ev)
end
function c101213011.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end