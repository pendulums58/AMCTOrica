--시계탑의 자각자
function c101213323.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,c101213323.twfilter,c101213323.twfilter1,1,true,true)
	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c101213323.cost)
	e1:SetCondition(c101213323.con)
	e1:SetTarget(c101213323.target)
	e1:SetOperation(c101213323.activate)
	c:RegisterEffect(e1)
	--카운터 놓는다
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101213323,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101213323.spcon)
	e2:SetTarget(c101213323.sptg)
	e2:SetOperation(c101213323.spop)
	c:RegisterEffect(e2)
end
function c101213323.twfilter(c)
	return c:IsCode(101213309)
end
function c101213323.twfilter1(c)
	return c:IsSetCard(0x60a) and c:IsType(TYPE_MONSTER)
end
function c101213323.filter(c)
	return c:IsSetCard(0x60a) and c:IsDiscardable()
end
function c101213323.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101213323.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213323.filter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101213323.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101213323.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101213323.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101213323.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x60a)
end
function c101213323.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c101213323.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_FZONE) and chkc:IsCode(75041269) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,75041269) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_FZONE,0,1,1,nil,75041269)
end
function c101213323.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local ct=Duel.GetMatchingGroupCount(c101213323.cfilter,tp,LOCATION_MZONE,0,nil)
		tc:AddCounter(0x1b,ct)	
	end
end