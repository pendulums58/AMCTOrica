--시계탑의 정비사
function c101213304.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,c101213304.twfilter,c101213304.twfilter1,1,true,true)
	--소환 제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101213304.splimit)
	c:RegisterEffect(e1)
	--특소 성공시 유옥의 시계탑의 효과 변경
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c101213304.sdop)
	c:RegisterEffect(e2)
	--전투 내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c101213304.twfilter(c)
	return c:IsCode(75041269) and c:GetCounter(0x1b)>=2
end
function c101213304.twfilter1(c)
	return c:IsSetCard(0x60a) and c:IsType(TYPE_MONSTER)
end
function c101213304.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(75041269) or se:GetHandler():IsCode(101213309)
end
function c101213304.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(101213304)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end