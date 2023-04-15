--문답무용의 이나리사마
function c111310082.initial_effect(c)
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--특수 소환한 몬스터의 이전 장소로 이동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c111310082.plcost)
	e1:SetCountLimit(1)
	e1:SetCondition(c111310082.plcon)
	e1:SetTarget(c111310082.pltg)
	e1:SetOperation(c111310082.plop)
	c:RegisterEffect(e1)	
end
function c111310082.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c111310082.plfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:GetSummonLocation()~=LOCATION_EXTRA and c:GetSummonLocation()~=LOCATION_DECK
end
function c111310082.plcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c111310082.plfilter,1,nil,tp)
end
function c111310082.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c111310082.ffilter(c,tc)
	return c:IsType(TYPE_MONSTER)
		and c:GetOriginalLevel()==tc:GetOriginalLevel()
		and c:GetOriginalRace()==tc:GetOriginalRace()
		and c:GetOriginalAttribute()==tc:GetOriginalAttribute()
		and not c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
		and c:IsAbleToHand()
end
function c111310082.plop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()	
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c111310082.ffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
	if g:GetCount()>0 then
		if eg:IsExists(c111310082.thfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(111310082)~=1 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		if eg:IsExists(c111310082.trfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(111310182)~=1 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		if eg:IsExists(c111310082.tgfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(111310282)~=1 then
			Duel.SendtoGrave(g,POS_FACEUP,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c111310082.thfilter(c,tp)
	return c:GetControler()==tp and c:IsPreviousLocation(LOCATION_HAND)
end
function c111310082.trfilter(c,tp)
	return c:GetControler()==tp and c:IsPreviousLocation(LOCATION_REMOVED)
end
function c111310082.tgfilter(c,tp)
	return c:GetControler()==tp and c:IsPreviousLocation(LOCATION_GRAVE)
end