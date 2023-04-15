--뇌명이 울리는 순간
function c101262009.initial_effect(c)
	--발동 1(카드 파괴)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(101262009,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101262009)
	e1:SetCost(c101262009.cost)
	e1:SetTarget(c101262009.destg)
	e1:SetOperation(c101262009.desop)
	c:RegisterEffect(e1)
	--발동 2(뇌명 소생)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(101262009,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101262009)
	e2:SetCost(c101262009.cost)
	e2:SetTarget(c101262009.sptg)
	e2:SetOperation(c101262009.spop)
	c:RegisterEffect(e2)
end
function c101262009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101262009.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c101262009.costfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if g:GetFirst():IsCode(101262000) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function c101262009.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x62d) and c:IsAbleToGraveAsCost()
end
function c101262009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_ONFIELD)
	else
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,LOCATION_ONFIELD)
	end
end
function c101262009.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if e:GetLabel()==1 then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c101262009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101262009.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101262009.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,c101262009.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	local g1=Duel.GetMatchingGroup(c101262009.thfilter,tp,LOCATION_GRAVE,0,nil)
	if e:GetLabel()==1 and g1:GetCount()>0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),tp,LOCATION_GRAVE)
	end
end
function c101262009.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if e:GetLabel()==1 then
			local g=Duel.SelectMatchingCard(tp,c101262009.thfilter,tp,LOCATION_GRAVE,0,1,3,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(g,1-tp)
			end
		end
	end
end
function c101262009.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(56260110)
end
function c101262009.spfilter(c,e,tp)
	return c:IsSetCard(0x62d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end