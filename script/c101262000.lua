--뇌명의 전조
function c101262000.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101262000.cost)
	e1:SetCountLimit(1,101262000+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101262000.activate)
	c:RegisterEffect(e1)
	--몬스터 효과 발동 불가 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101262000.condition)
	e2:SetOperation(c101262000.operation)
	c:RegisterEffect(e2)
	--뇌명 회수
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101262000,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c101262000.thcon)
	e3:SetTarget(c101262000.thtg)
	e3:SetOperation(c101262000.thop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101262000,ACTIVITY_SPSUMMON,c101262000.counterfilter)
end
function c101262000.counterfilter(c)
	return c:IsSetCard(0x62d)
end
function c101262000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101262000,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101262000.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101262000.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x62d)
end
function c101262000.filter(c)
	return c:IsSetCard(0x62d) and c:IsAbleToHand()
end
function c101262000.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101262000.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101262000,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101262000.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x62d) and bit.band(r,REASON_EFFECT)~=0
end
function c101262000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	if ep==tp then
		e1:SetTargetRange(1,0)
	else
		e1:SetTargetRange(0,1)
	end
	e1:SetValue(c101262000.aclimit1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_CARD,0,101262000)
end
function c101262000.aclimit1(e,re,tp)
	if re:GetCode()==EFFECT_RAIMEI_IM then return false end
	if re:GetHandler():GetCode()==101262010 then return false end
	return re:IsActiveType(TYPE_MONSTER)
end
function c101262000.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp
end
function c101262000.filter1(c)
	return c:IsCode(56260110) and c:IsAbleToHand()
end
function c101262000.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101262000.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101262000.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101262000.filter1,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101262000.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end