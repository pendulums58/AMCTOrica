--스타레일 포토그래퍼
function c101223175.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c101223173.unlockeff)
	--몬스터 업어 오기
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101223173.tg)
	e1:SetOperation(c101223173.op)
	c:RegisterEffect(e1)
end
function c101223173.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c101223173.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101223173.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local tc=Duel.SelectTarget(tp,c101223173.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,tp,LOCATION_GRAVE)
end
function c101223173.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(tc,1-tp)
	end
end
function c101223173.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetTurnID()==Duel.GetTurnCount()
end
function c101223173.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,101223175)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	Duel.RegisterEffect(e1,tp)
end