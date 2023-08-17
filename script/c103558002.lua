--네거티미드 퀀텀로지
local s,id=GetID()
function s.initial_effect(c)
	--링크 소환
	Link.AddProcedure(c,nil,2,3,s.lcheck)
	c:EnableReviveLimit()
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--퍼미션
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	--파괴 내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.indcon)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,SETCARD_NEGATIMID,lc,sumtype,tp)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g1:GetCount()>0 then
			Duel.Destroy(g1,REASON_EFFECT)
		end
	end
end
function s.cfilter(c)
	return c:IsAbleToGrave()
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ((c:GetFlagEffect(id)==0 and re:GetHandlerPlayer()==tp) or (c:GetFlagEffect(id+1)==0 and re:GetHandlerPlayer()==1-tp))
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsChainNegatable(ev) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) then
		local p=re:GetHandlerPlayer()
		if p==tp then
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
		else
			c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
		end
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandlerPlayer()==tp then
		Duel.RegisterFlagEffect(0,id+2,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.indcon(e)
	return Duel.GetFlagEffect(tp,id+2)>0
end