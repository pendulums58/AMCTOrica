--수렵구 - 구원 피리
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thfilter(c)
	return c:IsSetCard(SETCARD_HUNTER) and c:IsMonster() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	e:SetLabel(0)
	local ct=1
	if Duel.IsExistingMatchingCard(YiPi.SpellHunterCheck,tp,LOCATION_SZONE,0,1,nil) then
		e:SetLabel(1)
		ct=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local chk=e:GetLabel()
	local ct=1
	if chk then ct=2 end
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,1075) then
			local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			return Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.ssfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,1075) then
			local g1=Duel.SelectMatchingCard(tp,s.ssfilter,tp,LOCATION_HAND,0,1,1,nil)
			local tc=g1:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			return tc:RegisterEffect(e1)	
		end		
	end
	
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(SETCARD_HUNTER) and c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false)
end
function s.ssfilter(c)
	return c:IsSetCard(SETCARD_HUNTER) and not c:IsForbidden()
end