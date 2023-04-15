--안개에 숨은 바르그 프레키
function c111335003.initial_effect(c)
--자체 특소
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111335003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,111335003)
	e1:SetCondition(c111335003.spcon)
	e1:SetTarget(c111335003.sptg)
	e1:SetOperation(c111335003.spop)
	c:RegisterEffect(e1)	
--내성
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111335000,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,111335503)
	e2:SetTarget(c111335003.target)
	e2:SetOperation(c111335003.operation)
	c:RegisterEffect(e2)		
end
--자체 특소
function c111335003.spfilter2(c,tp)
	return c:IsFaceup() and c:IsCode(111335009)
end
function c111335003.spfilter(c)
	return c:GetEquipGroup():IsExists(c111335003.spfilter2,1,nil,nil) and c:IsFaceup()
end
function c111335003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c111335003.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c111335003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c111335003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--내성
function c111335003.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_SYNCHRO)
end
function c111335003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c111335003.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c111335003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c111335003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c111335003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c111335003.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c111335003.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end