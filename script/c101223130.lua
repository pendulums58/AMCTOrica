--시간동작 부적
function c101223130.initial_effect(c)
	--스탠바이까지 제외
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetDescription(aux.Stringid(101223130,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101223130.tg)
	e1:SetOperation(c101223130.op)
	c:RegisterEffect(e1)
	--2드로
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(101223130,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c101223130.cost)
	cyan.JustDraw(e2,2)
	c:RegisterEffect(e2)
	--특수 소환하지 않은 몬스터 파괴
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(101223130,2))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c101223130.destg)
	e3:SetOperation(c101223130.desop)
	c:RegisterEffect(e3)
end
function c101223130.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsAbleToRemove() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c101223130.rmfilter,tp,LOCATION_MZONE,0,1,nil) end
	local tc=Duel.SelectTarget(tp,c101223130.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tp,LOCATION_MZONE)
end
function c101223130.rmfilter(c)
	return c:IsAbleToRemove()
end
function c101223130.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local fid=c:GetFieldID()
			local rct=1
			if Duel.GetCurrentPhase()==PHASE_STANDBY then rct=2 end
			local og=Duel.GetOperatedGroup()
			local oc=og:GetFirst()
			while oc do
				oc:RegisterFlagEffect(101223130,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,rct,fid)
				oc=og:GetNext()
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(og)
			e1:SetCondition(c101223130.retcon)
			e1:SetOperation(c101223130.retop)
			if Duel.GetCurrentPhase()==PHASE_STANDBY then
				e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
				e1:SetValue(Duel.GetTurnCount())
			else
				e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
				e1:SetValue(0)
			end
			Duel.RegisterEffect(e1,tp)		
		end
	end
end
function c101223130.retfilter(c,fid)
	return c:GetFlagEffectLabel(101223130)==fid
end
function c101223130.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()==e:GetValue() then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c101223130.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c101223130.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c101223130.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end
function c101223130.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSummonType,1,nil,SUMMON_TYPE_SPECIAL) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSummonType,1,1,nil,SUMMON_TYPE_SPECIAL)
	Duel.Release(g,REASON_COST)
end
function c101223130.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsStatus(STATUS_SPSUMMON_TURN) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c101223130.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tc=Duel.SelectTarget(tp,c101223130.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_MZONE)
end
function c101223130.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c101223130.desfilter(c)
	return c:IsStatus(STATUS_SPSUMMON_TURN)
end