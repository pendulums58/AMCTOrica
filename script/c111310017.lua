--어드민즈 트랜스미션
function c111310017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111310017)
	e1:SetCondition(c111310017.condition)
	e1:SetTarget(c111310017.target)
	e1:SetOperation(c111310017.activate)
	c:RegisterEffect(e1)	
end
function c111310017.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_ACCESS)
end
function c111310017.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c111310017.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c111310017.filter(c)
	return c:IsSetCard(0x606) and c:IsAbleToHand()
end
function c111310017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310017.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111310017.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111310017.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsType(TYPE_MONSTER) and tc:GetLevel()<=4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetAdminCount(tp,1,nil)>0
			and Duel.SelectYesNo(tp,aux.Stringid(111310017,0)) then
			if Duel.RemoveAdmin(tp,1,0,1,1,REASON_EFFECT)~=0 then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end