--스러진 기억의 잔류물
local s,id=GetID()
function s.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,s.unlockeff)	
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	cyan.AddCannotExtraMat(c)
end
function s.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(0,LOCATION_GRAVE)
	e1:SetValue(s.val)
	e1:SetCondition(s.con)
	Duel.RegisterEffect(e1,tp)
end
function s.con(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsOwner,tp,0,LOCATION_MZONE,1,nil,tp)
end
function s.val(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil) 
		and e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	g:Merge(Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil))
	g:Merge(Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil))
	if g:GetCount()==3 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=e:GetHandler()
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.GetControl(tc,1-tp,PHASE_END,1)
		end
	end
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(87902575)
end
function s.thfilter1(c)
	return c:IsAbleToHand() and c:IsCode(50292967)
end
function s.thfilter2(c)
	return c:IsAbleToHand() and c:IsSetCard(SETCARD_DILETANT)
end