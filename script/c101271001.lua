--월하보은 - 달 아래서의 은혜
function c101271001.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101271001)
	e1:SetCondition(c101271001.spcon)
	c:RegisterEffect(e1)
	--묘지의 이 카드를 덱으로 되돌리고 몬스터를 이동
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101271000,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,101271101)
	e2:SetCondition(c101271001.seqcon)
	e2:SetCost(c101271001.seqcost)
	e2:SetTarget(c101271001.seqtg)
	e2:SetOperation(c101271001.seqop)
	c:RegisterEffect(e2)
	--링크 소재로 되었을 때 1장 묻기
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,101271911)
	e3:SetCondition(c101271001.grcon)
	e3:SetTarget(c101271001.grtg)
	e3:SetOperation(c101271001.grop)
	c:RegisterEffect(e3)
end
--1번 효과 구현
function c101271001.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x642)
end
function c101271001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101271001.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
--2번 효과 구현
function c101271001.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c101271001.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c101271001.seqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetSequence()~=1
end
function c101271001.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dd=Duel.GetFieldCard(tp,LOCATION_MZONE,1)
	if dd~=nil then return false end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101271001.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101271001.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101271001,1))
	Duel.SelectTarget(tp,c101271001.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101271001.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 and tc:GetSequence() ~= 1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	--local dd=Duel.GetFieldCard(tp,LOCATION_MZONE,1)
	--Debug.Message(dd)
	Duel.MoveSequence(tc,1)
end
--3번 효과 구현
function c101271001.grcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x642)
end
function c101271001.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101271001.grfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101271001.grop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101271001.grfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101271001.grfilter(c)
	return c:IsSetCard(0x642) and c:IsAbleToGrave()
end