--시계탑의 톱니기룡
function c101213301.initial_effect(c)
	--유옥 서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101213301,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101213301)
	e1:SetTarget(c101213301.target)
	e1:SetOperation(c101213301.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--벗어나면 카운터 놓기
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101213301,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101213401)
	e3:SetCondition(c101213301.spcon)
	e3:SetTarget(c101213301.sptg)
	e3:SetOperation(c101213301.spop)
	c:RegisterEffect(e3)
end
function c101213301.filter(c)
	return c:IsCode(75041269) and c:IsAbleToHand()
end
function c101213301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213301.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101213301.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101213301.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101213301.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c101213301.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x60a)
end
function c101213301.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_FZONE) and chkc:IsCode(75041269) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,75041269) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_FZONE,0,1,1,nil,75041269)
end
function c101213301.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local ct=Duel.GetMatchingGroupCount(c101213301.cfilter,tp,LOCATION_ONFIELD,0,nil)
		tc:AddCounter(0x1b,ct)	
	end
end