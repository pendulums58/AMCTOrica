--뇌명, 영원한 밤에 새기는
function c101262011.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c101262011.unlockeff)	
	--전투 / 효과 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c101262011.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--충전 효과
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EFFECT_RAIMEI_IM)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c101262011.descon)
	e3:SetTarget(c101262011.destg)
	e3:SetOperation(c101262011.desop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101262011,ACTIVITY_CHAIN,c101262011.chainfilter)	
end
function c101262011.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c101262011.ccon)
	e1:SetOperation(c101262011.cop)
	Duel.RegisterEffect(e1,tp)
end
function c101262011.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101262011.cop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.CreateToken(tp,56260110)
	Duel.Hint(HINT_CARD,0,101262011)
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(tc,1-tp)
end
function c101262011.indcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFlagEffect(tp,101262011)~=0
end
function c101262011.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(56260110)
end
function c101262011.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101262011,tp,ACTIVITY_CHAIN)~=0
end
function c101262011.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c101262011.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		if tc:IsType(TYPE_XYZ) then lv=tc:GetRank() end
		if tc:IsType(TYPE_LINKN) then lv=tc:GetLink() end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,lv*200,REASON_EFFECT)
		end
	end
end