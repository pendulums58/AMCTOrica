--환계룡 - 승화
function c101263002.initial_effect(c)
	--특소 제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101263002.splimit)
	c:RegisterEffect(e1)
	--찍고 제외
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101263002,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_END_PHASE)
	e2:SetCountLimit(1,101263002)
	e2:SetTarget(c101263002.rmtg)
	e2:SetOperation(c101263002.rmop)
	c:RegisterEffect(e2)	
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c101263002.discon2)
	c:RegisterEffect(e3)
	--묘지효과
	local e4=Effect.CreateEffect(c)	
	e4:SetDescription(aux.Stringid(101263002,1))	
	e4:SetType(EFFECT_TYPE_QUICK_O)	
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)	
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,101263002)
	e4:SetHintTiming(TIMING_END_PHASE)
	e4:SetCost(c101263002.spcost)	
	e4:SetCondition(c101263002.setcon)	
	e4:SetOperation(c101263002.setop)	
	c:RegisterEffect(e4)		
end
--특소제약
function c101263002.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x62e)
end
--제외효과
function c101263002.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c101263002.discon2(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c101263002.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==1-tp
end
function c101263002.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101263002.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local ct=1
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then ct=2 end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c101263002.retcon)
		e1:SetOperation(c101263002.retop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
		end
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(101263002,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,ct)
	end
end
function c101263002.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffect(101263002)~=0
end
function c101263002.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
--묘지효과
function c101263002.setcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetCurrentPhase()==PHASE_END
end
function c101263002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c101263002.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
