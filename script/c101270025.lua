--검의 종점
local s,id=GetID()
function s.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	--해금
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(s.ulcon)
	e1:SetRange(LOCATION_HAND)
	e1:SetUnlock(id+1)	
	e1:SetTarget(s.tg(e1:GetTarget()))
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(s.checkop1)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,id)>14
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
end
function s.tg(f)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		f(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==1 then
			Duel.SetChainLimit(aux.FALSE)
		end
	end
end
function s.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local loc,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	local tc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and tc:IsRelateToEffect(re) and loc==LOCATION_MZONE then
		tc:RegisterFlagEffect(101270031,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end