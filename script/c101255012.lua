--환영검성 샤마르
function c101255012.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101255012.afil1,aux.TRUE)
	c:EnableReviveLimit()	
	--소환 성공시
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101255012)
	e1:SetCondition(cyan.AccSSCon)
	e1:SetTarget(c101255012.target)
	e1:SetOperation(c101255012.operation)
	c:RegisterEffect(e1)
	--공격력 조작
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c101255012.cost)
	e2:SetTarget(c101255012.atktg)
	e2:SetOperation(c101255012.atkop)
	c:RegisterEffect(e2)
end
function c101255012.afil1(c)
	return c:IsSetCard(0x627)
end
function c101255012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<8 end
end
function c101255012.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=8-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local g=Group.CreateGroup()
	while ct>0 do
		local token=Duel.CreateToken(tp,101255008)
		g:AddCard(token)
		ct=ct-1
	end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(g,1-tp)
end
function c101255012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101255012.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101255012.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c101255012.cfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsDiscardable() and c:IsSetCard(0x627)
end
function c101255012.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c101255012.ctchk,tp,LOCATION_ONFIELD,0,1,nil) end
	local tc=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101255012.ctchk(c)
	return c:IsFaceup() and c:IsSetCard(0x627)
end
function c101255012.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local val=Duel.GetMatchingGroupCount(c101255012.ctchk,tp,LOCATION_ONFIELD,0,nil)*200
		local ud=Duel.SelectOption(tp,aux.Stringid(101255005,0),aux.Stringid(101255005,1))
		if ud==0 then
		
		else
			val=val*-1
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(val)
		tc:RegisterEffect(e1)
	end
end