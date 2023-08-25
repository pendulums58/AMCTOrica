--수렵구 - 영웅의 비약
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,id)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c.RegisterEffect(e1)
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(SETCARD_HUNTTARGET)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(YiPi.SpellHunterCheck,tp,LOCATION_SZONE,0,1,nil) then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.htfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(SETCARD_HUNTER) and c:IsAttackAbove() and c:IsFaceup()
end
function s.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(s.htfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.atkfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(0)) then
		local atkg=Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil)
		local tc=Duel.SelectMatchingCard(tp,s.htfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if #atkg>0 and #tc>0 then
			local tcc=tc:GetFirst()
			local tg=atkg:GetMaxGroup(Card.GetAttack)
			local atk=tg:GetFirst():GetAttack()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tcc:RegisterEffect(e1,true)
		end
	end
end