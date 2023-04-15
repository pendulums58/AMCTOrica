--액세스 코드『인터듀오』
function c101253003.initial_effect(c)
	--패에서 특소
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101253003)
	e1:SetCondition(c101253003.spcon)
	e1:SetOperation(c101253003.spop)
	c:RegisterEffect(e1)	
	--오른쪽 & 왼쪽 이름 복사
	
end
function c101253003.spfilter(c,ft,tp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,c,c:GetCode())
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c101253003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c101253003.spfilter,1,nil,ft,tp)
end
function c101253003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c101253003.spfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end