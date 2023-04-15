--플라워힐의 토루스
function c103554002.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103554002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,103554002)
	e1:SetCondition(c103554002.spcon)
	e1:SetTarget(c103554002.sptg)
	e1:SetOperation(c103554002.spop)
	c:RegisterEffect(e1)
	--레벨 상승 + 덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,103554003)
	e2:SetCost(c103554002.cost)
	e2:SetTarget(c103554002.tg)
	e2:SetOperation(c103554002.op)
	c:RegisterEffect(e2)
	--함정 내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c103554002.condition)
	e3:SetOperation(c103554002.operation)
	c:RegisterEffect(e3)
end
function c103554002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and (re:GetHandler():IsType(TYPE_FIELD) or re:GetHandler():IsRace(RACE_PLANT)) and not e:GetHandler():IsReason(REASON_DRAW)
end
function c103554002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c103554002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c103554002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103554002.rfilter,tp,LOCATION_HAND,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c103554002.rfilter,tp,LOCATION_HAND,0,1,1,nil)
	if tc:GetCount()>0 then
		e:SetLabelObject(tc:GetFirst())
		Duel.ConfirmCards(tc,1-tp)
	end
end
function c103554002.rfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and not c:IsPublic()
end
function c103554002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103554002.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c103554002.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.SelectMatchingCard(tp,c103554002.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c103554002.tgfilter(c)
	return c:IsSetCard(0x657) and c:IsAbleToGrave()
end
function c103554002.condition(e,tp,eg,ep,ev,re,r,rp)
	local mt=eg:GetFirst():GetMaterial()
	return r==REASON_RITUAL and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
		and not mt:IsExists(Card.IsNotSetCard,1,nil,0x657)
end
function c103554002.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	while rc do
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(103554002,1))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c103554002.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1,true)
		rc=eg:GetNext()
	end
end
function c103554002.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
