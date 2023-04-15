--스카이워커 스트라토스피어
function c101214311.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c101214311.synfilter1),1)
	c:EnableReviveLimit()
	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cyan.SynSSCon)
	e1:SetCountLimit(1,101214311)
	e1:SetTarget(c101214311.drtg)
	e1:SetOperation(c101214311.drop)
	c:RegisterEffect(e1)
	--제외하고 발동
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cyan.selfrmcost)
	e2:SetTarget(c101214311.lvtg)
	e2:SetOperation(c101214311.lvop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
end
function c101214311.synfilter1(c)
	return c:IsSetCard(0xef5)
end
function c101214311.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101214311.ck,tp,LOCATION_MZONE,0,nil)
	local lv=g:GetSum(Card.GetLevel)
	if chk==0 then return lv>19 and Duel.IsPlayerCanDraw(tp,lv/2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,lv/2)
end
function c101214311.ck(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c101214311.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101214311.ck,tp,LOCATION_MZONE,0,nil)
	local lv=g:GetSum(Card.GetLevel)
	if lv>19 then
		Duel.Draw(tp,lv/20,REASON_EFFECT)
	end
end
function c101214311.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>0 end
end
function c101214311.lvop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(6)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c101214311.efilter)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c101214311.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():GetLevel()==0
end
