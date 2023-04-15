--유니에이트 퍼포스
function c101266012.initial_effect(c)
	c:SetUniqueOnField(1,0,101266012)	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--대상 및 효과 파괴 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c101266012.con)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--날개 카운터 적립
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c101266012.ctcon)
	e3:SetOperation(c101266012.ctop)
	c:RegisterEffect(e3)
	--데미지 감소
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetValue(c101266012.damval)
	c:RegisterEffect(e4)
	--날개 카운터 제거
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c101266012.rmcon)
	e6:SetOperation(c101266012.rmop)
	c:RegisterEffect(e6)
end
function c101266012.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<3
end
function c101266012.filter(c)	
	return c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and c:IsSetCard(0x634)
end
function c101266012.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101266012.filter,nil)
	if g:GetCount()==0 then return false end
	return 1-tp==Duel.GetTurnPlayer()
end
function c101266012.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101266012.filter,nil)
	local ct=g:GetSum(Card.GetLevel,nil)
	if ct>0 then e:GetHandler():AddCounter(0x1324,ct) end
end
function c101266012.damval(e,re,val,r,rp,rc)
	local ct=e:GetHandler():GetCounter(0x1324)
	if ct==0 then return val end
	local val=val-(ct*100)
	if val<0 then val=0 end
	return val
end
function c101266012.rmcon(e)
	local tp=e:GetHandler():GetControler()
	return e:GetHandler():GetCounter(0x1324)>9 and  tp==Duel.GetTurnPlayer()
end
function c101266012.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=e:GetHandler():GetCounter(0x1324)
	if e:GetHandler():RemoveCounter(tp,0x1324,ct,REASON_EFFECT)~=0 then
		--이 턴에 무효화 불가 부여
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_INACTIVATE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		e4:SetValue(c101266012.effectfilter)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_DISEFFECT)
		e5:SetReset(RESET_PHASE+PHASE_END)
		e5:SetValue(c101266012.effectfilter)
		Duel.RegisterEffect(e5,tp)	
	end
end
function c101266012.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x634) and te:GetHandler():IsType(TYPE_MONSTER)
end
