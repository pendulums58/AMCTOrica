--마칭 파이어 예레미아
function c103549004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,103549004)
	e1:SetCondition(c103549004.spcon)
	e1:SetOperation(c103549004.spop)
	c:RegisterEffect(e1)
	--deck search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103549004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,103549904)
	e2:SetCondition(c103549004.thcon)
	e2:SetTarget(c103549004.thtg)
	e2:SetOperation(c103549004.thop)
	c:RegisterEffect(e2)
end
c103549004.counter_add_list={0x1325}
function c103549004.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c103549004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c103549004.filter,tp,LOCATION_HAND,0,1,c)
end
function c103549004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c103549004.filter,tp,LOCATION_HAND,0,1,1,c)
	Duel.Destroy(g,REASON_EFFECT)
end
function c103549004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c103549004.thfilter(c)
	return c:IsSetCard(0xac6) and not c:IsCode(103549004) and c:IsAbleToHand()
end
function c103549004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103549004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c103549004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c103549004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			if Duel.IsEnvironment(82705573,PLAYER_ALL,LOCATION_ONFIELD) and Duel.SelectYesNo(tp,aux.Stringid(103549004,2))
			and Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,nil,0x1325,1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local t=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,1,nil,0x1325,1)
			Duel.SetOperationInfo(0,CATEGORY_COUNTER,t,1,0x1325,1)
			local tc=Duel.GetFirstTarget()
				if tc:IsFaceup() and tc:IsRelateToEffect(e) then
				tc:AddCounter(0x1325,1)
				end
			end
		end
	end
end