--밀고의 괴도 베르너
local s,id=GetID()
function s.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,s.unlockeff)	
	
	--개방 시 카드 창조
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,116000906)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	e1:SetTarget(s.mktg)
	e1:SetOperation(s.mkop)
	c:RegisterEffect(e1)
	
	--창조된 카드 사용 시 필드 1장 파괴
	
end
function s.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(116000006)
	e1:SetTargetRange(1,0)
	Duel:RegisterEffect(e1,tp)
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