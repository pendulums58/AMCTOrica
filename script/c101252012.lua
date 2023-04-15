--한정해제자 니힐리스
function c101252012.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c101252012.unlockeff)
	--한정해제 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101252012.sptg)
	e1:SetOperation(c101252012.spop)
	c:RegisterEffect(e1)
	--회복
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101252012.condition)
	e2:SetOperation(c101252012.operation)
	c:RegisterEffect(e2)
end
function c101252012.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c101252012.rcchk,1,nil,tp)
end
function c101252012.rcchk(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c101252012.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(e:GetHandlerPlayer(),1000,REASON_EFFECT)
end

function c101252012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101252012.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c101252012.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,c101252012.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if tc:IsType(TYPE_RITUAL) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetOperation(c101252012.desop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			tc:RegisterEffect(e1,true)
		end
	end
end
function c101252012.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c101252012.spfilter(c,e,tp)
	return c:IsSetCard(0x625) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101252012.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(c101252012.reptg)
	e1:SetValue(c101252012.repval)
	Duel.RegisterEffect(e1,tp)	
end
function c101252012.target(e,c)
	return c:IsType(TYPE_RITUAL) and c:IsFaceup()
end
function c101252012.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_RITUAL)
		and c:GetFlagEffect(101252012)==0
end
function c101252012.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101252012.repfilter,1,nil,tp) end
	return true
end
function c101252012.repval(e,c)
	return c101252012.repfilter(c,e:GetHandlerPlayer())
end
function c101252012.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(101252012,RESET_EVENT+RESETS_STANDARD,0,1)
		tc=g:GetNext()
	end
end
