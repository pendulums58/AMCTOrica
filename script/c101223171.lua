--못미더운 해방자
function c101223171.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223171.pfilter,c101223171.mfilter,3,3)
	c:EnableReviveLimit()
	--효과 무효 적용 X
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.PairSSCon)
	e1:SetOperation(c101223171.sdop)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101223171.descost)
	e2:SetTarget(c101223171.destg)
	e2:SetOperation(c101223171.desop)
	c:RegisterEffect(e2)
end
function c101223171.pfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c101223171.mfilter(c,pair)
	return c:IsAttribute(pair:GetAttribute())
end
function c101223171.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_NEGATE_CANCEL)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c101223171.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetMaterial()
	if chk==0 then return Duel.IsExistingMatchingCard(c101223171.costfilter,tp,LOCATION_GRAVE,0,1,nil,g) end
	local rg=Duel.SelectMatchingCard(tp,c101223171.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,g)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c101223171.costfilter(c,g)
	return g:IsContains(c) and c:IsReason(REASON_MATERIAL+REASON_PAIRING) and c:IsAbleToRemoveAsCost()
end
function c101223171.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(CATEGORY_DESTROY,0,g,1,tp,LOCATION_ONFIELD)
end
function c101223171.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetValue(c101223171.aclimit)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetTarget(c101223171.sumlimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)	
		end
	end
end
function c101223171.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
