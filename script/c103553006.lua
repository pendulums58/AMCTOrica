--보세이아 공방
function c103553006.initial_effect(c)
	aux.AddCodeList(c,103553000)
	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,103553006)
	e1:SetCondition(cyan.IsUnlockState)
	e1:SetTarget(c103553006.drtg)
	e1:SetOperation(c103553006.drop)
	c:RegisterEffect(e1)
	--수비력 상승
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c103553006.tdcost)
	e2:SetCondition(c103553006.poscon)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c103553006.postg)
	e2:SetOperation(c103553006.posop)
	c:RegisterEffect(e2)
end
function c103553006.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and ct>0 
		and Duel.IsPlayerCanDraw(tp,ct) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)	
end
function c103553006.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
	if ct>0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function c103553006.tdfilter(c)
	return aux.IsCodeListed(c,103553000) and c:IsAbleToDeckAsCost() and not c:IsCode(103553006)
end
function c103553006.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c103553006.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>=1 and e:GetHandler():IsAbleToDeckAsCost() end
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,1)
	sg1:AddCard(e:GetHandler())
	Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c103553006.poscon(e,tp,eg,ep,ev,re,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c103553006.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) 
		and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.IsExistingTarget(c103553006.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	local tc=Duel.SelectTarget(tp,c103553006.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,LOCATION_MZONE)
end
function c103553006.tgfilter(c)
	return c:IsCanChangePosition()
end
function c103553006.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1500)
		tc:RegisterEffect(e1)
		cyan.AddFuriosoStack(tp,1)
	end
end