--듀얼리티: 체이서
function c101223126.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroMixProcedure(c,c101223126.matfilter1,nil,nil,aux.NonTuner(),1,99)
	c:EnableReviveLimit()
	--듀얼 재소환 취급
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	e1:SetCode(EFFECT_DUAL_STATUS)
	c:RegisterEffect(e1)
	--일반소환시
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c101223126.con)
	e2:SetTarget(c101223126.tg)
	e2:SetOperation(c101223126.op)
	c:RegisterEffect(e2)
end
function c101223126.matfilter1(c)
	return c:IsType(TYPE_TUNER) or c:IsType(TYPE_DUAL)
end
function c101223126.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223126.chk,1,nil,TYPE_NORMAL+TYPE_EFFECT+TYPE_DUAL)
end
function c101223126.chk(c,ty)
	return c:IsType(ty) and c:IsControler(tp)
end
function c101223126.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return (eg:IsExists(c101223126.chk,1,nil,TYPE_NORMAL) and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP))
		or (eg:IsExists(c101223126.chk,1,nil,TYPE_EFFECT))
		or (eg:IsExists(c101223126.chk,1,nil,TYPE_DUAL) and Duel.IsExistingMatchingCard(c101223126.thfilter,tp,LOCATION_DECK,0,1,nil))
	end
	if eg:IsExists(c101223126.chk,1,nil,TYPE_NORMAL) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	end
	if eg:IsExists(c101223126.chk,1,nil,TYPE_DUAL) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end	
end
function c101223126.thfilter(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToHand()
end
function c101223126.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c101223126.chk,1,nil,TYPE_NORMAL) then
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	if eg:IsExists(c101223126.chk,1,nil,TYPE_DUAL) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(400)
		c:RegisterEffect(e1)
	end	
	if eg:IsExists(c101223126.chk,1,nil,TYPE_DUAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101223126.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end		
end
function c101223126.filter(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToHand()
end