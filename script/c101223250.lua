--진홍왕의 주시
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FlAG_CARD_TARGET)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--세트
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)	
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,LOCATION_MZONE,0,1,nil,LOCATION_EXTRA) then
		Duel.SetChainLimit(s.chlimit)	
	end
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.BreakEffect()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local code=tc:GetCode()
			local tm=2
			if Duel.GetTurnPlayer()==tp then
				tm=3
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetTarget(s.sumlimit)
			e1:SetLabel(code)
			e1:SetReset(RESET_PHASE+PHASE_END,tm)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			Duel.RegisterEffect(e2,tp)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_MSET)
			Duel.RegisterEffect(e3,tp)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CANNOT_ACTIVATE)
			e4:SetValue(s.aclimit)
			Duel.RegisterEffect(e4,tp)			
		end
	end
end
function s.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
function s.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsPreviousControler(1-tp)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end