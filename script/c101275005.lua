--상점의 비용이 20% 감소하고, 품절되지 않습니다
local s,id=GetID()
function s.initial_effect(c)
	--내 애완동물 못 봤어요?
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--헣호!
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocation(tp,LOCATION_SZONE)>0 end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
      Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
      local e1=Effect.CreateEffect(c)
      e1:SetCode(EFFECT_CHANGE_TYPE)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
      e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
      c:RegisterEffect(e1)		
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return YiPi.SpellHunterCheck(e:GetHandler())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(g,1-tp)
			if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,3,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				local g1=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
				if g1:GetCount()==3 then
					Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
					Duel.Draw(tp,1)
				end
			end
		end
	end
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(SETCARD_HUNT)
end
function s.tdfilter(c)
	return c:IsSetCard(SETCARD_HUNT) and c:IsAbleToDeck()
end