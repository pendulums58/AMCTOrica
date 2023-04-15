--MP4 디렉터
c111310088.AccessMonsterAttribute=true
function c111310088.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()	
	--묘지 무효
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c111310088.nscon)
	e1:SetOperation(c111310088.negop)
	c:RegisterEffect(e1)
	--공격력 상승
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310088,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c111310088.condition)
	e2:SetOperation(c111310088.operation)
	c:RegisterEffect(e2)
end
function c111310088.nscon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad and (ad:IsSetCard(0x606) or ad:IsAttribute(ATTRIBUTE_LIGHT)) 
end
function c111310088.negop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if ep~=tp and loc==LOCATION_GRAVE then
		Duel.NegateEffect(ev)
	end
end
function c111310088.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function c111310088.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end