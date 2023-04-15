--뇌명, 그믐달에 울리는
function c101262005.initial_effect(c)
	--엑시즈 조건
	aux.AddXyzProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x62d),4,2)
	c:EnableReviveLimit()
	--묘지 회수
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101262005,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101262005.thcost)
	e1:SetTarget(c101262005.thtg)
	e1:SetOperation(c101262005.thop)
	c:RegisterEffect(e1)
	--충전 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(101262005,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetCode(EFFECT_RAIMEI_IM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101262005.con)
	e2:SetOperation(c101262005.operation)
	c:RegisterEffect(e2)	
	--충전 실패
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c101262005.condition)
	e3:SetTarget(c101262005.target)
	e3:SetOperation(c101262005.activate)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101262005,ACTIVITY_CHAIN,c101262005.chainfilter)
end
function c101262005.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(56260110)
end
function c101262005.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101262005.filter(c)
	return c:IsSetCard(0x62d) and c:IsAbleToHand()
end
function c101262005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101262005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101262005.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101262005.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101262005.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101262005.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101262005,tp,ACTIVITY_CHAIN)~=0
end
function c101262005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c101262005.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101262005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local ct=3
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3 then ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,ct)
end
function c101262005.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=3
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3 then ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) end	
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.DiscardHand(tp,nil,ct,ct,REASON_EFFECT+REASON_DISCARD)
end
