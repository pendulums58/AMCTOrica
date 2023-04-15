--A(안티).컨티뉴엄-베릴
function c101235007.initial_effect(c)
	c:SetSPSummonOnce(101235007)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101235007.matfilter,1,1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c101235007.regop)
	c:RegisterEffect(e3)
end
function c101235007.matfilter(c)
	return c:IsLinkSetCard(0x653)
end
function c101235007.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101235007,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101235007)
	e1:SetCost(c101235007.cost)
	e1:SetTarget(c101235007.thtg)
	e1:SetOperation(c101235007.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c101235007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
end
function c101235007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c101235007.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetDeckbottomGroup(tp,1)
	if sg:GetFirst():IsAbleToHand() then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	else
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end

