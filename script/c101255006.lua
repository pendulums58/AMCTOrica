--환영검의 근원
function c101255006.initial_effect(c)
	--발동시 효과 처리
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101255006)
	e1:SetTarget(c101255006.target)
	e1:SetOperation(c101255006.activate)
	c:RegisterEffect(e1)
	--사라지기 전에 생성해서 확보
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetCountLimit(1)
	e2:SetTarget(c101255006.checktg)
	e2:SetOperation(c101255006.checkop)
	c:RegisterEffect(e2)
	--액세스 성공시
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101255006.atkcon)
	e3:SetOperation(c101255006.atkop)
	c:RegisterEffect(e3)
end
function c101255006.filter3(c)
	return c:IsSetCard(0x627) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101255006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101255006.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101255006.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101255006.filter3),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101255006.chkfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x627)
end
function c101255006.checktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101255006.chkfilter,1,nil) end
end
function c101255006.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101255006.chkfilter,nil)
	if g:GetCount()>1 then g=g:Select(tp,1,1,nil) end
	local token=Duel.CreateToken(tp,g:GetFirst():GetCode())
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
end
function c101255006.filter(c,tp)
	return c:IsSetCard(0x627) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_ACCESS)
end
function c101255006.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101255006.filter,1,nil,tp)
end
function c101255006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc1=g2:GetFirst()
	while tc1 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
		tc1=g2:GetNext()
	end
end