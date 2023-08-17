--추억룡 브라이텔지온
local s,id=GetID()
function s.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)	
	--개방
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DRAW)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ulcon)
	e1:SetUnlock(id+1)
	c:RegisterEffect(e1)
end
function s.ulcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and (r&REASON_RULE)~=0 and Duel.GetTurnPlayer()==tp then
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
		local tc=eg:GetFirst()
		while tc do
			if g:IsExists(Card.IsCode,1,nil,tc:GetCode()) then
				return true
			end
			tc=eg:GetNext()
		end	
	end
	return false
end