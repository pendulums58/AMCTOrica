--뇌명에 감싸이다
function c101262006.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101262006)
	e1:SetTarget(c101262006.target)
	e1:SetOperation(c101262006.activate)
	c:RegisterEffect(e1)
	--묘지 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCode(EFFECT_RAIMEI_IM)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c101262006.con)
	e2:SetOperation(c101262006.atkop)
	c:RegisterEffect(e2)	
	Duel.AddCustomActivityCounter(101262006,ACTIVITY_CHAIN,c101262006.chainfilter)
end
function c101262006.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(56260110)
end
function c101262006.filter(c)
	return c:IsSetCard(0x62d) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c101262006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101262006.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101262006.tgfilter(c)
	return c:IsSetCard(0x62d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101262006.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101262006.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsCode(56260110) and Duel.IsExistingMatchingCard(c101262006.tgfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(101262006,0)) then
				local tc=Duel.SelectMatchingCard(tp,c101262006.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
				if tc:GetCount()>0 then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
			end
	end
end
function c101262006.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101262006,tp,ACTIVITY_CHAIN)~=0
end
function c101262006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1000)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c101262006.aclimit1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)	
end
function c101262006.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_ONFIELD)
end