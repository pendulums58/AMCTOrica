--오버크로니클 데드엔드
function c101223041.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223041.pfilter,c101223041.mfilter,2,2)
	c:EnableReviveLimit()
	--샐비지
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCondition(cyan.PairSSCon)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c101223041.thtg)
	e1:SetOperation(c101223041.thop)
	c:RegisterEffect(e1)
	--프리체인
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c101223041.descon)
	e2:SetTarget(c101223041.destg)
	e2:SetOperation(c101223041.desop)
	c:RegisterEffect(e2)
end
function c101223041.pfilter(c)
	return c:IsLevel(1)
end
function c101223041.mfilter(c,pair)
	return c:IsAttribute(pair:GetAttribute())
end
function c101223041.thfilter(c,tp)
	return c:IsType(TYPE_FIELD) and (c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsAbleToHand()) or c:IsLocation(LOCATION_FZONE)
end
function c101223041.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101223041.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101223041.thfilter,tp,LOCATION_FZONE+LOCATION_GRAVE,LOCATION_FZONE,1,nil,tp) end
	local g=Duel.SelectTarget(tp,c101223041.thfilter,tp,LOCATION_FZONE+LOCATION_GRAVE,LOCATION_FZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,g:GetFirst():GetLocation())
end
function c101223041.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101223041.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101223041.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsType(TYPE_MONSTER) and chkc:IsLocation(LOCATION_GRAVE) and c101223041.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101223041.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c101223041.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)	
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c101223041.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c101223041.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tc:GetControler(),LOCATION_ONFIELD,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end