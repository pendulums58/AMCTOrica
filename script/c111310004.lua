--RSA 레이븐
c111310004.AccessMonsterAttribute=true
function c111310004.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310004.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--1드로
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310004,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c111310004.cost)
	e1:SetCondition(c111310004.drcon)
	e1:SetTarget(c111310004.drtarg)
	e1:SetOperation(c111310004.drop)
	c:RegisterEffect(e1)
	--공격 코스트
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c111310004.condition)
	e2:SetCost(c111310004.atcost)
	e2:SetOperation(c111310004.atop)
	c:RegisterEffect(e2)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCondition(c111310004.condition)
	e3:SetCode(0x10000000+111310004)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)	
end
function c111310004.afil1(c)
	return c:GetLevel()==1
end
function c111310004.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:GetLevel()==1
end
function c111310004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310004.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c111310004.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c111310004.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310004.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c111310004.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c111310004.condition(e)
	local c=e:GetHandler()
	return c:GetAdmin():GetLevel()==1
end
function c111310004.cfilter1(c)
	return c:IsType(TYPE_ACCESS+TYPE_LINK) and c:IsAbleToRemoveAsCost()
end
function c111310004.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(c111310004.cfilter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c111310004.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c111310004.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end