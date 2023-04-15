--이매진 페인터
function c111310131.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c111310131.unlockeff)	
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,111310131)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsSetCard,0x606)
	c:RegisterEffect(e1)
	--공격력 변환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310131,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cyan.dhcost(1))
	e2:SetTarget(c111310131.target)
	e2:SetOperation(c111310131.operation)
	c:RegisterEffect(e2)
end
function c111310131.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c111310131.val)
	Duel.RegisterEffect(e1,tp)	
end
function c111310131.val(e,c)
	if c:GetBaseAttack()<2000 then
		return -600
	else
		return 600
	end
end
function c111310131.filter(c)
	return c:IsFaceup() and not c:IsAttack(3000)
end
function c111310131.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c111310131.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c111310131.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c111310131.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c111310131.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(3000)
		tc:RegisterEffect(e1)
	end
end
