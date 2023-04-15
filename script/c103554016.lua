--플라워힐의 라시아
function c103554016.initial_effect(c)
	c:EnableReviveLimit()
	--의식 소환시 파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cyan.RitSSCon)
	e1:SetCountLimit(1,103554016)
	e1:SetTarget(c103554016.destg)
	e1:SetOperation(c103554016.desop)
	c:RegisterEffect(e1)
	--내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c103554016.imcon)
	e2:SetValue(c103554016.efilter)
	c:RegisterEffect(e2)
	--공뻥
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,103554017)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetOperation(c103554016.op)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(103554016,ACTIVITY_CHAIN,c103554016.chainfilter)
end
function c103554016.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingMatchingCard(c103554016.costfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,nil) and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c103554016.costfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,2,nil)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_COST)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),tp,LOCATION_ONFIELD)
end
function c103554016.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg and tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c103554016.imcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.GetCustomActivityCount(103554016,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(103554016,1-tp,ACTIVITY_CHAIN)~=0)
end
function c103554016.costfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToDeckAsCost()
end
function c103554016.chainfilter(re,tp,cid)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_FIELD)
end
function c103554016.efilter(e,te)
	local tp=e:GetHandler():GetControler()
	return te:GetOwnerPlayer()~=tp and te:IsActiveType(TYPE_MONSTER)
end
function c103554016.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil,TYPE_FIELD)
	local ct=g1:GetClassCount(Card.GetCode)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(ct*500)
	c:RegisterEffect(e1)
end