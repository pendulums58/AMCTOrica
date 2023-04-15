--재앙의 전이
function c101223089.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223089.con)
	e1:SetOperation(c101223089.op)
	c:RegisterEffect(e1)
end
function c101223089.con(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)
	return ct>0
end
function c101223089.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.AddPlayerCounter(tp,0x1,1)
	if Duel.GetTurnPlayer()==1-tp then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):RandomSelect(tp,1)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end