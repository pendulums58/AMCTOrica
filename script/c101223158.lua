--시그너스의 지배력
function c101223158.initial_effect(c)
	c:SetUniqueOnField(1,0,101223158)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223158.actcon)
	c:RegisterEffect(e1)
	--싱크로 레벨 조정 기능
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c101223158.slevel)
	c:RegisterEffect(e2)
	--튜너 특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c101223158.cost)
	e3:SetTarget(c101223158.target)
	e3:SetOperation(c101223158.operation)
	c:RegisterEffect(e3)
	--공격력 상승
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c101223158.rmcon)
	e5:SetTarget(c101223158.rmtg)
	e5:SetOperation(c101223158.rmop)	
	c:RegisterEffect(e5)
end
function c101223158.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223158.chk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223158.chk(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c101223158.slevel(e,c)
	if c:GetLevel()==0 then return 0 end
	local lv=c:GetLevel()+1
	return lv*65536+c:GetLevel()
end
function c101223158.costfilter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function c101223158.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101223158.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c101223158.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c101223158.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223158.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223158.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c101223158.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101223158.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101223158.cfilter2(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c101223158.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223158.cfilter2,1,nil,tp)
end
function c101223158.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c101223158.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(300)
			sc:RegisterEffect(e1)
			sc=g:GetNext()
		end
	end
end
