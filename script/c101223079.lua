--문명을 부수는 자
function c101223079.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(c101223079.mfilter1),aux.FilterBoolFunction(c101223079.mfilter2),true)
	--상대 필드가 비어 있어야 융합 소환 가능
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101223079.sumlimit)
	c:RegisterEffect(e1)
	--상대 필드에 융합 소환됨
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_OPPO_FIELD_FUSION)
	e2:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e2)
	--융합 소환 성공시
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cyan.FuSSCon)
	e3:SetOperation(c101223079.op)
	c:RegisterEffect(e3)
	--엑트 특소 불가
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCondition(c101223079.discon)
	e4:SetTarget(c101223079.splimit)
	c:RegisterEffect(e4)
	--턴 경과
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(cyan.dhcost(1))
	e5:SetOperation(c101223079.op1)
	c:RegisterEffect(e5)
end
function c101223079.mfilter1(c)
	return c:GetCode()>=100000000
end
function c101223079.mfilter2(c)
	return c:GetCode()<100000000
end
function c101223079.sumlimit(e,se,sp,st,pos,tp)
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 or not bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c101223079.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveTurnCount()
	Duel.SetLP(tp,8000)
	Duel.SetLP(1-tp,8000)
	Duel.ResetTimeLimit(tp)
	Duel.ResetTimeLimit(1-tp)
end
function c101223079.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()%2==0
end
function c101223079.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c101223079.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveTurnCount()
end