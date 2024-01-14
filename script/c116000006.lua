--밀고의 괴도 베르너
local s,id=GetID()
function s.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,s.unlockeff)		
	--개방 시 카드 창조
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	e1:SetTarget(s.mktg)
	e1:SetOperation(s.mkop)
	c:RegisterEffect(e1)	
	--창조된 카드 사용 시 필드 1장 파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(116000006)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
s.listed_series={0xefb}
s.listed_names={id}
function s.mktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() or chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceUp,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
end
function s.mkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()	
	if tc:IsRelateToEffect(e) then
		local token=Duel.CreateToken(tp,tc:GetCode())
		Duel.SendtoHand(token,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,token)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return not c:IsHasEffect(id) and ep==tp
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end