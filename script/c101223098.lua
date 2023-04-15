--그리자이유의 마신
function c101223098.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223098.pfilter,c101223098.mfilter,2,2)
	c:EnableReviveLimit()	
	--공격력 상승
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c101223098.op)
	c:RegisterEffect(e1)
	--파괴시
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c101223098.con)
	e2:SetTarget(c101223098.tg)
	e2:SetOperation(c101223098.op1)
	c:RegisterEffect(e2)
end
function c101223098.pfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c101223098.mfilter(c,pair)
	return c:IsRace(pair:GetRace())
end
function c101223098.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c101223098.filter,1,nil,c) and not eg:IsContains(c) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1500)
		tc:RegisterEffect(e1)
	end
end
function c101223098.filter(c,tc)
	if not c:IsSummonLocation(LOCATION_EXTRA) then return false end
	local g=tc:GetPair()
	if g:GetCount()>0 then
		if c:IsType(TYPE_SYNCHRO) and g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then return true end
		if c:IsType(TYPE_FUSION) and g:IsExists(Card.IsType,1,nil,TYPE_FUSION) then return true end
		if c:IsType(TYPE_XYZ) and g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then return true end
		if c:IsType(TYPE_ACCESS) and g:IsExists(Card.IsType,1,nil,TYPE_ACCESS) then return true end
		if c:IsType(TYPE_LINK) and g:IsExists(Card.IsType,1,nil,TYPE_LINK) then return true end
		if c:IsType(TYPE_PENDULUM) and g:IsExists(Card.IsType,1,nil,TYPE_PENDULUM) then return true end
	end
end
function c101223098.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT+REASON_PAIR)
end
function c101223098.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsSummonLocation(LOCATION_EXTRA) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSummonLocation,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,LOCATION_EXTRA) end
	local tc=Duel.SelectTarget(tp,Card.IsSummonLocation,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_MZONE)
end
function c101223098.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end