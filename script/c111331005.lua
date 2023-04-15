--시간을 관측하는 딜레탕트
function c111331005.initial_effect(c)
--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--되돌리기	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111331005,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,111331005)
	e2:SetCondition(c111331005.con)
	e2:SetOperation(c111331005.op)
	c:RegisterEffect(e2)	
--링크 소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111331005,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,111331505)
	e3:SetCondition(c111331005.spcon)
	e3:SetCost(c111331005.spcost)
	e3:SetTarget(c111331005.sptg)
	e3:SetOperation(c111331005.spop)
	c:RegisterEffect(e3)	
end
function c111331005.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c111331005.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c111331005.cfilter,1,nil,tp)
end
function c111331005.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.HintSelection(sg)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
end
--링크 소환
function c111331005.spcon(e,c)
	local c=e:GetHandler()
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>1
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c111331005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c111331005.spfilter(c)
	return c:IsCode(111331100)
end
function c111331005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111331005.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c111331005.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c111331005.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()	
	local c=e:GetHandler()
		if g:GetCount()>0 then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end