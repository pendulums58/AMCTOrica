--무라쿠모식 환성장회
function c103551008.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103551008,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c103551008.tgcon)
	e1:SetCountLimit(1,103551008+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c103551008.tg)
	e1:SetOperation(c103551008.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c103551008.condition)
	c:RegisterEffect(e2)
	--묘지 효과
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(93298460,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c103551008.thcost)
	e3:SetCondition(c103551008.thcon)
	cyan.JustSearch(e3,LOCATION_DECK,Card.IsNotCode,103551008,Card.IsSetCard,0x64b)
	c:RegisterEffect(e3)
end
function c103551008.negfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x64b) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c103551008.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c103551008.negfilter,1,nil,tp)
end
function c103551008.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:GetControler()==tp and a:IsSetCard(0x64b) and a:IsRelateToBattle())
		or (d and d:GetControler()==tp and d:IsSetCard(0x64b) and d:IsRelateToBattle())
end
function c103551008.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c103551008.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c103551008.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c103551008.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if b then ft=ft-1 end
	if chk==0 then return ft>0
		and Duel.IsExistingMatchingCard(c103551008.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
end
function c103551008.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.SelectMatchingCard(tp,c103551008.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if tc:GetCount()>0 then tc=tc:GetFirst() end
	if tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c103551008.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end
function c103551008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c103551008.thchk,1,nil,tp)
end
function c103551008.thchk(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_PAIRING) and c:IsPreviousControler(tp)
end
function c103551008.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c103551008.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c103551008.costfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then g:AddCard(e:GetHandler()) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c103551008.costfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end