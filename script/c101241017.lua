--미드윈터 리서처
function c101241017.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101241017.pfilter,c101241017.mfilter,1,1)
	c:EnableReviveLimit()
	--나이트 샷
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101241017.target)
	e1:SetOperation(c101241017.activate)
	c:RegisterEffect(e1)
end
function c101241017.pfilter(c)
	return not c:IsLevel(3) and c:IsType(TYPE_EFFECT)
end
function c101241017.mfilter(c,pair)
	return c:IsDisabled()
end
function c101241017.cfilter(c,prcl)
	return c:IsFaceup() and c:IsLevel(prcl)
end
function c101241017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local pr=e:GetHandler():GetPair()
	local prc=pr:GetFirst()
	local ct=0
	while prc do
		local prcl=prc:GetLevel()
		if Duel.IsExistingTarget(c101241017.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),prcl) then
			ct=1
		end
		prc=pr:GetNext()
	end
	if chk==0 then return ct==1 end
end
function c101241017.activate(e,tp,eg,ep,ev,re,r,rp)
	local pr=e:GetHandler():GetPair()
	local prc=pr:GetFirst()
	while prc do
		local prcl=prc:GetLevel()
		local g=Duel.GetMatchingGroup(c101241017.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),prcl)
		local tc=g:GetFirst()
		while tc do
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
			tc=g:GetNext()
		end
		prc=pr:GetNext()
	end
end