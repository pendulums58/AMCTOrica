--컨티뉴엄 리서처
function c101235004.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101235004,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c101235004.cost)
	e1:SetTarget(c101235004.settg)
	e1:SetCountLimit(1,101235004)
	e1:SetOperation(c101235004.setop)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101235004,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c101235004.thtg)
	e4:SetOperation(c101235004.thop)
	c:RegisterEffect(e4)
end
function c101235004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c101235004.filter(c)
	return c:IsCode(81674782) and c:IsSSetable()
end
function c101235004.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101235004.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c101235004.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c101235004.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c101235004.thfilter(c)
	return c:IsFacedown()
end
function c101235004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101235004.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
end
function c101235004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101235004.thfilter,tp,LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local tcode=tc:GetCode()
			Duel.Exile(tc,REASON_EFFECT)
			local token=Duel.CreateToken(tp,tcode)
			Duel.Remove(token,POS_FACEUP,REASON_EFFECT)
			tc=g:GetNext()
		end
	end
end
