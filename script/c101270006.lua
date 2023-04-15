--소망을 쫓는 어드바이저
c101270006.AmassEffect=1
function c101270006.initial_effect(c)
	--서치?
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101270006)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101270006.thtg)
	e1:SetOperation(c101270006.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--축적
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,101270106)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(c101270006.amtg)
	e3:SetOperation(c101270006.amop)
	c:RegisterEffect(e3)
end
function c101270006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) then 
			return Duel.IsExistingMatchingCard(c101270006.thfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		else
			return Duel.IsExistingMatchingCard(c101270006.thfilter,tp,LOCATION_DECK,0,1,nil)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) then 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,niil,1,tp,LOCATION_ONFIELD)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end	
end
function c101270006.thfilter(c)
	return c:IsAbleToHand() and c.AmassEffect
end
function c101270006.thfilter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101270006.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c101270006.thfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end	
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101270006.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end		
end
function c101270006.amtg(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return Duel.AmassCheck(tp) end
end
function c101270006.amop(e,tp,ep,eg,ev,re,r,rp)
	Duel.Amass(e,800)
end