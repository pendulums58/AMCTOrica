--몰아치는 꽃보라
function c101223090.initial_effect(c)
	c:SetSPSummonOnce(101223090)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223090.pfilter,c101223090.mfilter,1,1)
	c:EnableReviveLimit()		
	--페어링 성공시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCCESS)
	e1:SetCondition(cyan.PairSSCon)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	cyan.JustSearch(e1,LOCATION_GRAVE+LOCATION_REMOVED,Card.IsType,TYPE_QUICKPLAY,Card.IsNotSetCard,0x46)
	c:RegisterEffect(e1)
	--샐비지
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(c101223090.thcost)
	e2:SetTarget(c101223090.thtg)
	e2:SetOperation(c101223090.thop)
	c:RegisterEffect(e2)
end
function c101223090.pfilter(c)
	return c:IsType(TYPE_FUSION)
end
function c101223090.mfilter(c,pair)
	return aux.IsMaterialListCode(pair,c:GetCode())
end
function c101223090.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223090.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c101223090.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if tc:GetCount()>0 then
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
		e:SetLabelObject(tc)
	end
end
function c101223090.costfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c101223090.thfilter,tp,LOCATION_GRAVE,0,1,c,c)
end
function c101223090.thfilter(c,fc)
	return c:IsAbleToHand() and aux.IsMaterialListCode(fc,c:GetCode())
end
function c101223090.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c101223090.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.SelectMatchingCard(tp,c101223090.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end