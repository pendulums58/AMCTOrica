--카와카제식 환성궁술
function c103551010.initial_effect(c)
	--장착
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,103551010+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c103551010.tg)
	e1:SetOperation(c103551010.op)
	c:RegisterEffect(e1)
	--묘지 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c103551010.thcost)
	e2:SetCondition(c103551010.thcon)
	e2:SetTarget(c103551010.target1)
	e2:SetOperation(c103551010.activate1)
	c:RegisterEffect(e2)
end
function c103551010.eqfilter(c,e,tp)
	return c:IsType(TYPE_EQUIP) and Duel.IsExistingMatchingCard(c103551010.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,c)
end
function c103551010.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x64b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and tc:CheckEquipTarget(c)
end
function c103551010.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if b then ft=ft-1 end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c103551010.eqfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ft>0 and
		Duel.IsExistingTarget(c103551010.eqfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c103551010.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c103551010.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c103551010.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
		if g:GetCount()>0 then
			local ttc=g:GetFirst()
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:CheckEquipTarget(ttc) then
				Duel.Equip(tp,tc,ttc)
			end
		end
	end
end
function c103551010.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c103551010.thchk,1,nil,tp)
end
function c103551010.thchk(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_PAIRING) and c:IsPreviousControler(tp)
end
function c103551010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c103551010.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c103551010.costfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then g:AddCard(e:GetHandler()) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c103551010.costfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function c103551010.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c103551010.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c103551010.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end