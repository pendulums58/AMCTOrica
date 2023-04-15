--고백의 나이트패스
function c101223113.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223113.pfilter,c101223113.mfilter,1,1)
	c:EnableReviveLimit()	
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.PairSSCon)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c101223113.destg)
	e1:SetOperation(c101223113.desop)
	c:RegisterEffect(e1)
end
function c101223113.pfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c101223113.mfilter(c,pair)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and not c:IsAttribute(pair:GetAttribute())
end
function c101223113.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetPair()
	if chk==0 then return Duel.IsExistingMatchingCard(c101223113.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,g,g) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_MZONE)
end
function c101223113.desfilter(c,g)
	return g:IsExists(Card.IsAttribute,1,nil,c:GetAttribute())
end
function c101223113.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetPair()
	local g1=Duel.SelectMatchingCard(tp,c101223113.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g,g)
	if g1:GetCount()>0 then
		Duel.Destroy(g1,REASON_EFFECT)
	end
end