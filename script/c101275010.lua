--수렵구 - 구원 피리
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.tgfilter(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local tc=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if Duel.IsExistingMatchingCard(YiPi.SpellHunterCheck,tp,LOCATION_SZONE,0,1,nil) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			if e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
	end
end
function s.tgfilter(c,e,tp)
	return c:IsSetCard(SETCARD_HUNTER) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function s.spfilter(c,e,tp,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(SETCARD_HUNTER) and c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false) and not c:IsCode(code)
end