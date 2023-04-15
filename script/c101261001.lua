--BST 더스트업
function c101261001.initial_effect(c)
	--이름 변경
	local e1=Effect.CreateEffect(c)
	e1:SetRange(LOCATION_HAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101261001)
	e1:SetCost(c101261001.cost)
	e1:SetTarget(c101261001.target)
	e1:SetOperation(c101261001.operation)
	c:RegisterEffect(e1)
	--싱크로 소재 시
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101261001,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,101261101)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c101261001.reccon)
	e2:SetTarget(c101261001.rectg)
	e2:SetOperation(c101261001.recop)
	c:RegisterEffect(e2)
end
function c101261001.cost(e,tp,eg,ev,ep,re,rp,r,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)	
end
function c101261001.filter(c)
	return c:IsFaceup() and not c:IsCode(101261000)
end
function c101261001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101261001.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101261001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101261001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c101261001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(101261000)
		tc:RegisterEffect(e1)
	end
end
function c101261001.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c101261001.filter1(c)
	return c:IsSetCard(0x62b) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c101261001.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101261001.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101261001.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101261001.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end