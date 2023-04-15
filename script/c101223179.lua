--천공영사 아테르시아
function c101223179.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c101223179.unlockeff)
	--개방시 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c101223179.thtg)
	e1:SetOperation(c101223179.thop)
	c:RegisterEffect(e1)
	--기동 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c101223179.atkcost)
	e2:SetOperation(c101223179.atkop)
	c:RegisterEffect(e2)
end
function c101223179.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,CARD_SANCTUARY_SKY))
	e1:SetValue(c101223179.indct)
	Duel.RegisterEffect(e1,tp)
end
function c101223179.indct(e,re,r,rp)
	if r&REASON_EFFECT==REASON_EFFECT then
		return 1
	else
		return 0
	end
end
function c101223179.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c101223179.thfilter1,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c101223179.thfilter2,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c101223179.thfilter3,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c101223179.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c101223179.thfilter1,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c101223179.thfilter2,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c101223179.thfilter3,tp,LOCATION_REMOVED,0,1,nil) then
		local g=Duel.SelectMatchingCard(tp,c101223179.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		local g1=Duel.SelectMatchingCard(tp,c101223179.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		g:Merge(g1)
		local g2=Duel.SelectMatchingCard(tp,c101223179.thfilter3,tp,LOCATION_REMOVED,0,1,1,nil)
		g:Merge(g2)
		if g:GetCount()==3 then
			local cg=g:RandomSelect(1-tp,1)
			local tc=cg:GetFirst()
			tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			g:Sub(cg)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)	
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)	
			Duel.ShuffleDeck(tp)
		end
	end
end
function c101223179.thfilter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_TUNER) and c:IsRace(RACE_FAIRY)
end
function c101223179.thfilter2(c)
	return c:IsAbleToHand() and c:ListsCode(CARD_SANCTUARY_SKY)
end
function c101223179.thfilter3(c)
	return c:IsAbleToHand() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) and c:IsLevel(4)
end
function c101223179.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsRace,1,false,nil,e:GetHandler(),RACE_FAIRY) end
	local sg=Duel.SelectReleaseGroupCost(tp,Card.IsRace,1,1,false,nil,e:GetHandler(),RACE_FAIRY)
	Duel.Release(sg,REASON_COST)
end
function c101223179.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsFaceup() then
		--Increase ATK
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
