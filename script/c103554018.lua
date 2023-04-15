--플라워힐의 알메리아
function c103554018.initial_effect(c)
	c:EnableReviveLimit()
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cyan.RitSSCon)
	e1:SetCountLimit(1,103554018)
	e1:SetTarget(c103554018.thtg)
	e1:SetOperation(c103554018.thop)
	c:RegisterEffect(e1)
	--퍼미션
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,103554019)
	e2:SetCondition(c103554018.discon)
	e2:SetCost(c103554018.discost)
	e2:SetTarget(c103554018.distg)
	e2:SetOperation(c103554018.disop)
	c:RegisterEffect(e2)	
end
function c103554018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103554018.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)>0 then
		e:SetLabel(1)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_FZONE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_FZONE)
	else
		e:SetLabel(0)
	end
end
function c103554018.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c103554018.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
		if e:GetLabel()==1 and Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)>0 then
			local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_FZONE,0,nil)		
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
		end
	end
end
function c103554018.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x657) and c:IsType(TYPE_FIELD)
end
function c103554018.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c103554018.costfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToDeckAsCost()
end
function c103554018.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103554018.costfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,c103554018.costfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()==2 then
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end
end
function c103554018.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c103554018.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
