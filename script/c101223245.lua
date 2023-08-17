--추억룡 브라이텔지온
local s,id=GetID()
function s.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,s.unlockeff)	
	--개방 시 발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--무효화 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.effectfilter)
	c:RegisterEffect(e3)		
end
function s.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.op)
	Duel.RegisterEffect(e1,tp)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
	end
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:GetTurnID()==Duel.GetTurnCount()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,tp,nil,3,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter1,tp,LOCATION_DECK,0,nil)	
	local hg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		hg:AddCard(tc)
		g:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,hg)	
end
function s.thfilter1(c,tp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and Duel.IsExistingMatchingCard(s.chk,tp,LOCATION_GRAVE,0,1,nil,te:GetHandler())
end
function s.chk(c,tc)
	local code=tc:GetCode()
	return c:IsCode(code)
end