--천본 벚꽃
function c103555015.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	--키 해방
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c103555015.ulcon)
	e1:SetUnlock(103555016)
	c:RegisterEffect(e1)
end
function c103555015.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and Duel.GetTurnPlayer()==tp	
end