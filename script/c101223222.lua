--영원 커넥터
local s,id=GetID()
function s.initial_effect(c)
	--패 발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(cyan.selfdiscost)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.drcon1)
	e1:SetOperation(s.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(s.drcon2)
	e3:SetOperation(s.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.filter(c,sp)
	local loc=c:GetSummonLocation()
	return c:GetSummonPlayer()==sp and not (loc==LOCATION_HAND or loc==LOCATION_GRAVE)
end
function s.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,1-tp) 
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function s.drop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(1-tp,id)
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)	
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,1-tp) 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id+100,RESET_CHAIN,0,1)
end
function s.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+100)>0
end
function s.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,id+100)
	Duel.ResetFlagEffect(tp,id)
	local ct=Duel.GetFlagEffect(1-tp,id)
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)	
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
	end
end
