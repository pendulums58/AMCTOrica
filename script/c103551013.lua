--명환성검 어나더크레센트
function c103551013.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	--키 해방
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_LEAVE_FIELD_P)
	e1:SetOperation(c103551013.eqcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c103551013.spcon2)
	e2:SetUnlock(103551014)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c103551013.chk(c)
	return c:IsType(TYPE_PAIRING) and c:GetEquipCount()>1 and c:GetDestination()==LOCATION_GRAVE
end
function c103551013.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c103551013.chk,nil)
	if g:GetCount()>0 then e:SetLabel(1)
	else e:SetLabel(0) end
	-- if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	-- g:KeepAlive()
	-- e:SetLabelObject(g)
end
function c103551013.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end