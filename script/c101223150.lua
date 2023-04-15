--프라임 패스『퓨전』
function c101223150.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,c101223150.ffilter,1,1,c101223150.ffilter1,c101223150.ffilter2,c101223150.ffilter3)
	--융합 소환으로만 소환 가능
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--소환 턴 라이프 변화 없음
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c101223150.sdop)
	c:RegisterEffect(e2)
	--전투 내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--회수
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c101223150.con)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	cyan.JustSearch(e4,LOCATION_GRAVE,Card.IsAbleToHand,1)
	c:RegisterEffect(e4)
end
function c101223150.ffilter(c,fc)
	return c:GetSummonLocation()==LOCATION_HAND
end
function c101223150.ffilter1(c,fc)
	return c:GetSummonLocation()==LOCATION_DECK
end
function c101223150.ffilter2(c,fc)
	return c:GetSummonLocation()==LOCATION_GRAVE
end
function c101223150.ffilter3(c,fc)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c101223150.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_LP_CANNOT_CHANGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c101223150.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end