--마칭 파이어 이스카리엘
function c103549000.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,103549000)
	e1:SetCondition(c103549000.effcon)
	c:RegisterEffect(e1)
	--counter_Return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103549000,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,103549900)
	e2:SetCondition(c103549000.spcon)
	e2:SetTarget(c103549000.sptg)
	e2:SetOperation(c103549000.spop)
	c:RegisterEffect(e2)
end
c103549000.counter_add_list={0x1325}
function c103549000.cfilter(c)
	return c:IsFaceup() and c:IsCode(82705573)
end
function c103549000.effcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c103549000.cfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c103549000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c103549000.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_SZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,nil,0x1325,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,1,nil,0x1325,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x1325,1)
end
function c103549000.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x1325,1)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end