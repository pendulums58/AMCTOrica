--스카이워커 럭스
function c101214004.initial_effect(c)
	--레벨 6 증가
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112400512,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101214904)
	e1:SetCost(c101214004.cost)
	e1:SetTarget(c101214004.target)
	e1:SetOperation(c101214004.operation)
	c:RegisterEffect(e1)
	--묘지에서 특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400502,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,101214004)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c101214004.spcon)
	e2:SetTarget(c101214004.target1)
	e2:SetOperation(c101214004.operation1)
	c:RegisterEffect(e2)	
end
function c101214004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101214004.filter1(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c101214004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101214004.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101214004.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101214004.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101214004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(6)
		tc:RegisterEffect(e1)
	end
end
function c101214004.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c101214004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c101214004.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101214004.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101214004.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c101214004.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101214004.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_THUNDER) and c:IsLocation(LOCATION_EXTRA)
end