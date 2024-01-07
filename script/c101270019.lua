--스타더스트 프레이어
local s,id=GetID()
function s.initial_effect(c)
	--1장만 존재 가능
	c:SetUniqueOnField(1,0,id)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,s.unlockeff)	
	--무한 싱크로 가능
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(id)
	e0:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e0)
	--레벨 변환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)
end
function s.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.tg)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)	
end
function s.tg(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local op=0
	local c=e:GetHandler()
	if c:IsLevel(7) and c:IsTuner() then
		op=1
	else
		if c:IsLevel(1) and not c:IsTuner() then
			op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		else
			op=0
		end
	end
	
	if op==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(7)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_TUNER)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)		
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_TUNER)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)			
	end
end