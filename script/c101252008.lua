--한정해제-천벌
function c101252008.initial_effect(c)
	c:EnableReviveLimit()
	--파괴 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetCondition(c101252008.condition)	
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101252008.desreptg)
	c:RegisterEffect(e1)
	--전투 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--카드 효과 무효
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101252008,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101252008.discon)
	e3:SetTarget(c101252008.distg)
	e3:SetOperation(c101252008.disop)
	c:RegisterEffect(e3)
end
function c101252008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101252008.desfilter(c,e)
	return c:IsFaceup() and c:IsDestructable(e)
end
function c101252008.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c101252008.desfilter,tp,0,LOCATION_ONFIELD,1,nil,e) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local tc=Duel.SelectMatchingCard(tp,c101252008.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			return true
		end
	end
	return false
end
function c101252008.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c101252008.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c101252008.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		local g=Group.CreateGroup()
		g:AddCard(e:GetHandler())
		g:Merge(eg)
		Duel.Destroy(g,REASON_EFFECT)
		
	end
end
