--재건자의 부적
function c101223054.initial_effect(c)
	--어둠 회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(101223054,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101223054.target)
	e1:SetOperation(c101223054.activate)
	c:RegisterEffect(e1)
	--축적
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetDescription(aux.Stringid(101223054,1))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c101223054.amtg)
	e2:SetOperation(c101223054.amop)
	c:RegisterEffect(e2)
	--무효
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetDescription(aux.Stringid(101223054,2))
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(c101223054.distg)
	e3:SetOperation(c101223054.disop)
	c:RegisterEffect(e3)	
end
function c101223054.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c101223054.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c101223054.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101223054.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101223054.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101223054.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c101223054.amtg(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return Duel.AmassCheck(tp) end
end
function c101223054.amop(e,tp,ep,eg,ev,re,r,rp)
	Duel.Amass(e,1200)
end
function c101223054.negfilter(c,val)
	return c:IsAttackBelow(val) and not c:IsDisabled()
end
function c101223054.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN):GetSum(Card.GetAttack,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223054.negfilter,tp,0,LOCATION_MZONE,1,nil,val) end
end
function c101223054.disop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN):GetSum(Card.GetAttack,nil)
	local g=Duel.SelectMatchingCard(tp,c101223054.negfilter,tp,0,LOCATION_MZONE,1,1,nil,val)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end