--신살마녀 버베리피아
function c101226019.initial_effect(c)
	--패에서 특소
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101226019.spcon)
	e1:SetOperation(c101226019.spop)
	c:RegisterEffect(e1)
	--덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101226019,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c101226019.spcon1)
	e2:SetTarget(c101226019.thtg)
	e2:SetOperation(c101226019.thop)
	c:RegisterEffect(e2)	
end
function c101226019.spfilter(c,ft,tp)
	return c:IsSetCard(0x612)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c101226019.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c101226019.spfilter,1,nil,ft,tp)
end
function c101226019.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c101226019.spfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c101226019.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_ACCESS and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c101226019.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101226019.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(c101226019.chainlm)
end
function c101226019.filter1(c)
	return c:IsSetCard(0x612) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101226019.chainlm(e,rp,tp)
	return tp==rp
end
function c101226019.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101226019.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end