--컨티뉴엄 시프트
function c101235011.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101235011,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101235011,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101235011)
	e2:SetCondition(c101235011.condition)
	e2:SetCost(c101235011.cost)
	e2:SetTarget(c101235011.target)
	e2:SetOperation(c101235011.activate)
	c:RegisterEffect(e2)
	--act in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c101235011.actcon)
	c:RegisterEffect(e3)
	if not c101235011.global_check then
		c101235011.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c101235011.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101235011.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:GetHandler():IsSetCard(0x653) then return end
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(101235011,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c101235011.actcon(e)
	return e:GetHandler():GetFlagEffect(101235011)>0
end
function c101235011.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	return Duel.IsChainNegatable(ev)
end
function c101235011.cfilter(c,type)
	return c:IsType(type) and c:IsFaceup()
end
function c101235011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local type=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c101235011.cfilter,tp,LOCATION_REMOVED,0,1,nil,type) end
	local g=Duel.SelectMatchingCard(tp,c101235011.cfilter,tp,LOCATION_REMOVED,0,1,1,nil,type)
	local tc=g:GetFirst()
	local tcode=tc:GetCode()
	Duel.Exile(tc,REASON_EFFECT)
	local token=Duel.CreateToken(tp,tcode)
	Duel.Remove(token,POS_FACEDOWN,REASON_EFFECT)
	tc=g:GetNext()
end
function c101235011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101235011.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
end
