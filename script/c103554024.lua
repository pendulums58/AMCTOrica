--플라워힐의 화이트블룸
function c103554024.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c103554024.ulcon)
	if c:IsOriginalCode(103554025) then
		e1:SetUnlock(103554027)
	else
		e1:SetUnlock(103554026)
	end
	c:RegisterEffect(e1)	
end
function c103554024.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return re and r==REASON_EFFECT and eg:IsExists(c103554024.chk,1,nil) and rp==tp
end
function c103554024.chk(c)
	return c:IsType(TYPE_FIELD)
end