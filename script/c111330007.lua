--잔불여우의 여행
function c111330007.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111330007)
	e1:SetTarget(c111330007.thtg)
	e1:SetOperation(c111330007.thop)
	c:RegisterEffect(e1)
end
function c111330007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111330007.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	end
end
function c111330007.thfilter(c)
	return c:IsSetCard(0x638) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c111330007.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c111330007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 
			and Cyan.EmberTokenCheck(tp) then
			local token=Cyan.CreateEmberToken(tp)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			Cyan.AddEmberTokenAttribute(token)
			Duel.SpecialSummonComplete()
		end
	end
end