--기원 벚꽃
function c103555012.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c103555012.pfilter,c103555012.mfilter,1,1)
	c:EnableReviveLimit()	
	--회수 및 드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,103555012)
	e1:SetCondition(cyan.PairSSCon)
	e1:SetTarget(c103555012.thtg)
	e1:SetOperation(c103555012.thop)
	c:RegisterEffect(e1)
	--턴 종료시 세트
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c103555012.sscost)
	e2:SetCountLimit(1)
	e2:SetTarget(c103555012.sstg)
	e2:SetOperation(c103555012.ssop)
	c:RegisterEffect(e2)
	cyan.AddSakuraEffect(c)
end
function c103555012.pfilter(c)
	return c:IsSetCard(0x65a)
end
function c103555012.mfilter(c,pair)
	return c:GetDefense()==pair:GetDefense()
end
function c103555012.tdfilter(c)
	return c:IsSetCard(0x65a) and c:IsAbleToDeck()
end
function c103555012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103555012.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
end
function c103555012.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c103555012.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c103555012.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetPair()
	if chk==0 then return Duel.IsExistingMatchingCard(c103555012.costfilter,tp,LOCATION_HAND,0,1,nil,g) end
	local g1=Duel.SelectMatchingCard(tp,c103555012.costfilter,tp,LOCATION_HAND,0,1,1,nil,g)
	if g1:GetCount()>0 then
		Duel.ConfirmCards(g1,1-tp)
	end
end
function c103555012.costfilter(c,g)
	return g:IsExists(Card.IsCode,1,nil,c:GetCode()) and not c:IsPublic()
end
function c103555012.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103555012.ssfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c103555012.ssfilter(c)
	return c:IsSetCard(0x65a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c103555012.ssop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c103555012.ssop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)	
end
function c103555012.ssop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,c103555012.ssfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end