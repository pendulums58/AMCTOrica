--진언전달자 시렌티아
function c101223083.initial_effect(c)
	--엑시즈
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()	
	--무효
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101223083,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101223083.negcon)
	e1:SetCost(c101223083.negcost)
	e1:SetTarget(c101223083.negtg)
	e1:SetOperation(c101223083.negop)
	c:RegisterEffect(e1)	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCost(cyan.htgcost(1))
	e2:SetCondition(c101223083.con)
	cyan.JustSearch(e2,LOCATION_DECK,Card.IsRace,RACE_FIEND)
	c:RegisterEffect(e2)
end
function c101223083.negcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATION_GRAVE,1,nil,tc:GetCode()) and Duel.IsChainNegatable(ev)
		and ep==1-tp and tc:IsType(TYPE_MONSTER)
end
function c101223083.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101223083.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101223083.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c101223083.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and bit.band(r,REASON_EFFECT)==REASON_EFFECT and c:IsPreviousLocation(LOCATION_ONFIELD)
end