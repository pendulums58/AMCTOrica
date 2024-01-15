--한정해제자 리미티아
local s,id=GetID()
function s.initial_effect(c)
	--의식 몬스터 취급
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(TYPE_RITUAL)
	c:RegisterEffect(e1)	
	local e0=e1:Clone()
	e0:SetRange(LOCATION_DECK)
	c:RegisterEffect(e0)
	--한정해제 카드 서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--릴리스하고 발동
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cyan.selfrelcost)
	e4:SetCountLimit(1,{id,1})
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL then
		Duel.SetOperationInfo(0,CATEGORY_DRAW+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end	
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
			and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(SETCARD_FOREGONE) and c:IsAbleToHand()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(id)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end