--BST MarL
function c101261013.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101261013.ulcon)
	e1:SetUnlock(101261014)
	c:RegisterEffect(e1)	
end
function c101261013.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101261013.chk,2,nil)
end
function c101261013.chk(c)
	return c:GetPreviousCodeOnField()==BLANK_NAME and c:IsPreviousLocation(LOCATION_ONFIELD)
end