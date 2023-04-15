--플래그마타의 수복
function c101265004.initial_effect(c)
	--드로우 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101265004)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c101265004.drcost)
	e1:SetTarget(c101265004.drtg)
	e1:SetOperation(c101265004.drop)
	c:RegisterEffect(e1)
	--패 매수 조절
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101265004.tg)
	e2:SetOperation(c101265004.op)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101265004,ACTIVITY_SPSUMMON,c101265004.counterfilter)	
end
function c101265004.counterfilter(c)
	return not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c101265004.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101265004,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101265004.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101265004.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c101265004.cfilter(c)
	return c:IsSetCard(0x633) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c101265004.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101265004.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsPlayerCanDraw(tp) end
	local ct=1
	for i=2,3 do
		if Duel.IsPlayerCanDraw(tp,i) then ct=i end
	end
	local g=Duel.SelectMatchingCard(tp,c101265004.cfilter,tp,LOCATION_HAND,0,1,ct,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())	
end
function c101265004.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101265004.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
end
function c101265004.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(4)
	Duel.RegisterEffect(e1,p)
end
