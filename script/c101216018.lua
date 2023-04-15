--성설신탁 프로스트위시
function c101216018.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101216018.pfilter,c101216018.mfilter,1,1)
	c:EnableReviveLimit()	
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101216018,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101216018.spcost)
	e1:SetTarget(c101216018.sptg)
	e1:SetOperation(c101216018.spop)
	c:RegisterEffect(e1)
	--소재시 서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101216018,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,101216018)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(cyan.htgcost(1))
	e2:SetCondition(c101216018.reccon)
	e2:SetTarget(c101216018.rectg)
	e2:SetOperation(c101216018.recop)
	c:RegisterEffect(e2)	
end
function c101216018.pfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c101216018.mfilter(c,pair)
	local lv=pair:GetLevel()
	return c:GetLevel()==lv*2 or c:GetLevel()*2==lv
end	
function c101216018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local pr=e:GetHandler():GetPair()
	if chk==0 then return pr:GetCount()>0 and Duel.IsExistingMatchingCard(c101216018.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,pr) end
	local rm=Duel.SelectMatchingCard(tp,c101216018.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,pr)
	if rm:GetCount()>0 then Duel.Remove(rm,POS_FACEUP,REASON_COST) end
end
function c101216018.costfilter(c,e,tp,pr)
	return pr:IsExists(Card.IsRace,1,nil,c:GetRace()) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101216018.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c,e,tp,pr)
end
function c101216018.spfilter(c,e,tp,pr)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and pr:IsExists(Card.IsLevel,1,nil,c:GetLevel())
		 and pr:IsExists(Card.IsAttribute,1,nil,c:GetAttribute())
end
function c101216018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local pr=e:GetHandler():GetPair()
	if chk==0 then return Duel.IsExistingMatchingCard(c101216018.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,pr) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c101216018.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local pr=e:GetHandler():GetPair()
	local g=Duel.SelectMatchingCard(tp,c101216018.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,pr)
	local tc=g:GetFirst()
	if tc then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end

end
function c101216018.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c101216018.filter(c)
	return c:IsSetCard(0x60f) and c:IsAbleToHand()
end
function c101216018.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101216018.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101216018.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101216018.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end