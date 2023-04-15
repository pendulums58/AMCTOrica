--미카즈키식 환성검기
function c103551012.initial_effect(c)
	--서치하거나 장착한다
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,103551012)
	e1:SetTarget(c103551012.target)
	e1:SetOperation(c103551012.operation)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c103551012.thcost)
	e2:SetCondition(c103551012.thcon)
	e2:SetTarget(c103551012.target1)
	e2:SetOperation(c103551012.activate1)
	c:RegisterEffect(e2)
end
function c103551012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if b then ft=ft-1 end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c103551012.tgfilter(chkc,tp,ft) end
	if chk==0 then return Duel.IsExistingTarget(c103551012.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp,ft) end
	local tc=Duel.SelectTarget(tp,c103551012.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c103551012.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if b then ft=ft-1 end
		local g=Duel.SelectMatchingCard(tp,c103551012.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,ft)
		if g:GetCount()>0 then
			local op=0
			if ft>0 then
				if g:GetFirst():IsAbleToHand() then
					op=Duel.SelectOption(tp,1068,1109)
				else
					op=0
				end
			else
				op=1
			end
			if op==0 then
				Duel.Equip(tp,g:GetFirst(),tc)
			else
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(g,1-tp)
			end
		end
	end
end
function c103551012.tgfilter(c,tp,ft)
	return c:IsFaceup() and c:IsSetCard(0x64b)
		and Duel.IsExistingMatchingCard(c103551012.eqfilter,tp,LOCATION_DECK,0,1,nil,c,ft)
end
function c103551012.eqfilter(c,tc,ft)
	return c:IsType(TYPE_EQUIP) and (c:IsAbleToHand() or ft>0) and c:CheckEquipTarget(tc)
end
function c103551012.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c103551012.thchk,1,nil,tp)
end
function c103551012.thchk(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_PAIRING) and c:IsPreviousControler(tp)
end
function c103551012.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c103551012.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c103551012.costfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then g:AddCard(e:GetHandler()) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c103551012.costfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function c103551012.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c103551012.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end