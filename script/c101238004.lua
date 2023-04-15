--테일테이머 토크
function c101238004.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,101238004)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101238004.target)
	e1:SetOperation(c101238004.activate)
	c:RegisterEffect(e1)	
end
function c101238004.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x619) and c:IsAbleToGrave()
end
function c101238004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101238004.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101238004.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101238004.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local tc=g:GetFirst()
		local loc=e:GetHandler():GetLocation()
		if loc==LOCATION_SZONE and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(101238004,0)) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		if loc==LOCATION_MZONE and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(101238004,1)) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		if loc==LOCATION_GRAVE and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(101238004,2)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end		
	end
end
