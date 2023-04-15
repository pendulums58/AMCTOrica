--차원에 홀로 서다
function c101223086.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101223086+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101223086.tg)
	e1:SetOperation(c101223086.op)
	c:RegisterEffect(e1)
end
function c101223086.costfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsAttack(1500) and c:IsDefense(1000) and c:IsLevel(4) and c:IsRace(RACE_BEASTWARRIOR)
end
function c101223086.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Group.CreateGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c101223086.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,g1)
		and Duel.IsExistingMatchingCard(c101223086.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101223086.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		e:SetLabelObject(g)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c101223086.op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local g1=Duel.SelectMatchingCard(tp,c101223086.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,g)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
	end
end
function c101223086.thfilter(c,g)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_ONFIELD) or c:IsAbleToHand()) and not g:IsContains(c)
end