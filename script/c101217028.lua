--에고파인더-인스팅트 슬래시
function c101217028.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c101217028.target)
	e1:SetOperation(c101217028.operation)
	c:RegisterEffect(e1)
	--장착제한
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c101217028.eqlimit)
	c:RegisterEffect(e2)
	--공뻥
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c101217028.atkval)
	c:RegisterEffect(e3)
	--연격
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,101217028)
	e4:SetCost(c101217028.macost)
	e4:SetOperation(c101217028.maop)
	c:RegisterEffect(e4)
end
function c101217028.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xef7)
end
function c101217028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101217028.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101217028.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c101217028.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101217028.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c101217028.eqlimit(e,c)
	return c:IsSetCard(0xef7)
end
function c101217028.atkfilter(c)
	return c:IsSetCard(0xef7) and c:IsType(TYPE_XYZ)
end
function c101217028.atkval(e,c)
	local g=Duel.GetMatchingGroup(c101217028.atkfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local dam=g:GetClassCount(Card.GetCode)
	return dam*700
end
function c101217028.mafilter(c)
	return c:IsOriginalCodeRule(101217001) and c:IsAbleToRemoveAsCost()
end
function c101217028.macost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101217028.mafilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101217028.mafilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101217028.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,101217000)
	local ct=g:GetCount()
	if ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct)
		c:RegisterEffect(e1)
	end
end