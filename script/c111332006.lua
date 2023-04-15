--미스트레이퍼 선셋
function c111332006.initial_effect(c)
--특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111332006)
	e1:SetTarget(c111332006.target)
	e1:SetOperation(c111332006.activate)
	c:RegisterEffect(e1)	
end
function c111332006.thfilter(c)
	return c:IsCode(111332007) and c:IsAbleToHand()
end
function c111332006.thfilter1(c)
	return c:IsSetCard(0x643) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c111332006.scchk(c,sc)
	return c:IsCode(sc) and c:IsFaceup()
end
function c111332006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then 
		local b1=Duel.IsExistingMatchingCard(c111332006.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c111332006.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c111332006.scchk,tp,LOCATION_FZONE,0,1,nil,111332007)
		return b1 or b2
		end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)	
end
function c111332006.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c111332006.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	if Duel.IsExistingMatchingCard(c111332006.scchk,tp,LOCATION_FZONE,0,1,nil,111332007) then
		local eg=Duel.GetMatchingGroup(c111332006.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		g:Merge(eg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
