--진원기록『신기루』
function c101246006.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101246006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101246006)
	e1:SetCondition(c101246006.condition)
	e1:SetTarget(c101246006.sptg)
	e1:SetOperation(c101246006.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_HAND)
	c:RegisterEffect(e2)	
	--동명 서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101246006,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101246106)
	e3:SetTarget(c101246006.target)
	e3:SetOperation(c101246006.operation)
	c:RegisterEffect(e3)
	--대상 내성 부여
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c101246006.imtg)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c101246006.cfilter(c,tp)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and Duel.IsExistingMatchingCard(c101246006.cfilter2,tp,LOCATION_MZONE,0,2,c,c:GetCode())
end
function c101246006.cfilter2(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c101246006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101246006.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c101246006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101246006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c101246006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)   
	if chkc then return chkc:IsFaceup() and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c101246006.tgfilter(chkc) end
	if chk ==0 then return Duel.IsExistingTarget(c101246006.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectTarget(tp,c101246006.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end	
function c101246006.tgfilter(c)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c101246006.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c101246006.thfilter(c,tc)
	return c:IsCode(tc:GetCode()) and c:IsAbleToHand()
end
function c101246006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c101246006.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101246006.imtg(e,c)
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,c,c:GetCode())
end