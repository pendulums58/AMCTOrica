--뇌명, 용오름에 이끌린
function c101262003.initial_effect(c)
	--자체 특소
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCountLimit(1,101262003)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101262003.spcon)
	c:RegisterEffect(e1)	
	--충전 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101262103)
	e2:SetCode(EFFECT_RAIMEI_IM)
	e2:SetCost(cyan.dhcost(1))
	e2:SetCondition(c101262003.thcon)
	cyan.JustSearch(e2,LOCATION_DECK,Card.IsSetCard,0x62d)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101262003,ACTIVITY_CHAIN,c101262003.chainfilter)
end
function c101262003.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(56260110)
end
function c101262003.spfilter(c)
	return c:IsFaceup() and c:IsCode(56260110)
end
function c101262003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101262003.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c101262003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101262003,tp,ACTIVITY_CHAIN)~=0
end