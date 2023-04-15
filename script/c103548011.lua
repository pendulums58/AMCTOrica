--OZ - 미지의 보우자 카라기리
function c103548011.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.NonTuner(Card.IsRace,RACE_PSYCHO),2)
	c:EnableReviveLimit()
	--send to grave or remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103548011,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,103548011)
	e1:SetCondition(c103548011.thcon)
	e1:SetTarget(c103548011.thtg)
	e1:SetOperation(c103548011.thop)
	c:RegisterEffect(e1)
	--life gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103548011,2))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,103548911)
	e2:SetTarget(c103548011.rctg)
	e2:SetOperation(c103548011.rcop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103548011,3))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,103548811)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c103548011.rmcost)
	e3:SetTarget(c103548011.rmtg)
	e3:SetOperation(c103548011.rmop)
	c:RegisterEffect(e3)
end
function c103548011.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c103548011.filter(c)
	return c:IsSetCard(0xac5) and (c:IsAbleToRemove() or c:IsAbleToGrave())
end
function c103548011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103548011.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c103548011.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c103548011.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,aux.Stringid(103548011,0),aux.Stringid(103548011,1))==0) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c103548011.costfilter(c)
	return c:IsFaceup() and c:IsCode(103548000) and c:IsAbleToGrave()
end
function c103548011.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c103548011.costfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103548011.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectTarget(tp,c103548011.costfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c103548011.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
function c103548011.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c103548011.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c103548011.rmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end