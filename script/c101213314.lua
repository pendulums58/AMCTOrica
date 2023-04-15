--0시를 알리는 시계
function c101213314.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--무효화
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c101213314.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--발동 제약
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c101213314.limcon)
	e3:SetOperation(c101213314.aclimit1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c101213314.limcon)
	e4:SetOperation(c101213314.aclimit2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c101213314.econ)
	e5:SetValue(c101213314.elimit)
	c:RegisterEffect(e5)
	--카운터 놓기
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(101213314,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1,101213314)
	e6:SetCost(c101213314.reccost)
	e6:SetTarget(c101213314.rectg)
	e6:SetOperation(c101213314.recop)
	c:RegisterEffect(e6)
end
function c101213314.disable(e,c)
	if Duel.GetCounter(0,1,0,0x1b)<12 then return false end
	return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
function c101213314.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(101213314,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c101213314.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(101213314)
end
function c101213314.econ(e)
	return e:GetHandler():GetFlagEffect(101213314)~=0
end
function c101213314.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c101213314.limcon(e)
	if Duel.GetCounter(0,1,0,0x1b)<24 then return false end
	return true
end
function c101213314.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c101213314.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_FZONE) and chkc:IsCode(75041269) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,75041269) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_FZONE,0,1,1,nil,75041269)
end
function c101213314.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:AddCounter(0x1b,1)	
	end
end