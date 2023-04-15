--로스트메모리 - 옐로우 카트레아
function c101249009.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FALSE,5,3,c101249009.ovfilter,aux.Stringid(101249009,0))  
	c:EnableReviveLimit()
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c101249009.xyzlimit)
	c:RegisterEffect(e0)
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101249009.target)
	e1:SetValue(c101249009.indct)
	c:RegisterEffect(e1)
	--엑시즈 특소
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101249009.cost)
	e2:SetTarget(c101249009.chtarget)
	e2:SetOperation(c101249009.choperation)
	c:RegisterEffect(e2)
end
function c101249009.ovfilter(c)
	return c:IsCode(101249008) 
end
function c101249009.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x623)
end
function c101249009.target(e,c)
	return c:IsCode(96765646) 
end
function c101249009.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c101249009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101249009.spfilter1(c)
	return c:IsFaceup()
end
function c101249009.chtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c101249009.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101249009.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c101249009.choperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsSetCard(0x623) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(96765646)
		tc:RegisterEffect(e1)
	else
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(101249015,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(96765646)
		tc:RegisterEffect(e1)
	end
end