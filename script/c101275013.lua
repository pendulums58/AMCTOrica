--수렵구 - 연기옥
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.imtg)
	e1:SetOperation(s.imop)
	c:RegisterEffect(e1)
end
function s.tgfilter(c)
	return c:IsSetCard(SETCARD_HUNTER) and c:IsFaceup()
end
function s.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.tgfilter(chkc) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local tc=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if Duel.IsExistingMatchingCard(YiPi.SpellHunterCheck,tp,LOCATION_SZONE,0,1,nil) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.thfilter(c)
	return c:IsSetCard(SETCARD_HUNTER) and c:IsType(TYPE_MONSTER)
end
function s.imop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		--Unaffected by opponent's card effects
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3110)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(s.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
	if ct==1 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(0)) then
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(g,1-tp)
		end
	end
end