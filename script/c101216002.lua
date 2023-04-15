--성설의 지휘자
function c101216002.initial_effect(c)
	--성설 서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101216002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101216002)
	e1:SetTarget(c101216002.target)
	e1:SetOperation(c101216002.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--제외되면 특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101216002,3))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c101216002.descon)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101216102)
	e3:SetTarget(c101216002.target1)
	e3:SetOperation(c101216002.operation1)
	c:RegisterEffect(e3)	
end
function c101216002.filter(c)
	return c:IsCode(89181369) and c:IsAbleToHand()
end
function c101216002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101216002.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101216002.descon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsCode(89181369)
end
function c101216002.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101216002.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101216002.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101216002.tgfilter(chkc,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101216002.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c101216002.tgfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c101216002.atkfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttack())
end
function c101216002.atkfilter(c,atk)
	return c:IsSetCard(0x60f) and c:GetAttack()<=atk and c:GetAttack()>0
end
function c101216002.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if tc and tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c101216002.atkfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttack())
		if g:GetCount()>0 then
			local atk=g:GetFirst():GetAttack()
			Duel.SendtoGrave(g,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
