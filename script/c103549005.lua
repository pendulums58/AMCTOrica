--마칭 파이어 로마네
function c103549005.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103549005,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,103549005)
	e1:SetTarget(c103549005.target)
	e1:SetOperation(c103549005.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spell th
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103549005,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,103549905)
	e3:SetCondition(c103549005.con)
	e3:SetTarget(c103549005.tg)
	e3:SetOperation(c103549005.op)
	c:RegisterEffect(e3)
end
function c103549005.tgfilter(c)
	return c:IsSetCard(0xac6) and c:IsAbleToGrave() and not c:IsCode(103549005)
end
function c103549005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103549005.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c103549005.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c103549005.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c103549005.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c103549005.thfilter(c)
	return c:IsCode(82705573) and c:IsAbleToHand()
end
function c103549005.thfilter2(c)
	return c:IsSetCard(0xac6) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand() and not c:IsCode(103549005)
end
function c103549005.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c103549005.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103549005.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c103549005.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c103549005.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT) then
		local g=Duel.GetMatchingGroup(c103549005.thfilter2,tp,LOCATION_GRAVE,0,nil)
		if Duel.IsEnvironment(82705573,PLAYER_ALL,LOCATION_ONFIELD) and Duel.SelectYesNo(tp,aux.Stringid(103549005,2)) and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sc=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
		end
	end
end