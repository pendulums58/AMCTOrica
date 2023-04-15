--환영검객 치누크
function c101255013.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	--해방
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_EQUIP)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101255013.thcon)
	e1:SetUnlock(101255014)
	c:RegisterEffect(e1)		
end
function c101255013.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c101255013.eqchk,1,nil)
end
function c101255013.eqchk(c)
	local tc=c:GetEquipTarget()
	return tc:IsType(TYPE_ACCESS) and tc:IsSetCard(0x627) and tc:GetEquipGroup():IsExists(aux.TRUE,1,c)
end