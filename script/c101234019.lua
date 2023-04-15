--극 여환무장【카와카제】
function c101234019.initial_effect(c)
	--융합 소재
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,101234003,aux.FilterBoolFunction(Card.IsFusionSetCard,0x611),1,true,true)
	--묘지 특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101234019)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101234019.spcon)
	e1:SetTarget(c101234019.sptg)
	e1:SetOperation(c101234019.spop)
	c:RegisterEffect(e1)
	--바운스
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101234019.thtg)
	e2:SetOperation(c101234019.thop)
	c:RegisterEffect(e2)	
	--회수
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCost(c101234019.ycon)
	e3:SetTarget(c101234019.tg)
	e3:SetOperation(c101234019.op)
	c:RegisterEffect(e3)
end
function c101234019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101234019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101234019.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SelectTarget(tp,c101234019.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101234019.filter(c,e,tp)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101234019.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if not g:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and not g:GetCount()>0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c101234019.tfilter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and not Duel.IsExistingMatchingCard(c101234019.bfilter,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function c101234019.bfilter(c,tc)
	return tc:IsCode(c:GetCode()) and c:IsFaceup()
end
function c101234019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101234019.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c101234019.ycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_EQUIP)
end
function c101234019.filter2(c)
	return c:IsSetCard(0x611) and c:IsAbleToHand()
end
function c101234019.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c101234019.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c101234019.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c101234019.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end