--월하관성 - 달 아래서 별을 보며
function c101271002.initial_effect(c)
	--패에서도 소재로 쓸 수 있음
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,101271002)
    e1:SetValue(c101271002.matval)
    c:RegisterEffect(e1)
	--묘지의 이 카드를 덱으로 되돌리고 몬스터를 이동
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101271000,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,101271102)
	e2:SetCondition(c101271002.seqcon)
	e2:SetCost(c101271002.seqcost)
	e2:SetTarget(c101271002.seqtg)
	e2:SetOperation(c101271002.seqop)
	c:RegisterEffect(e2)
	--이 카드를 링크 소재로 해 나온 몹에게 효과 완전 내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e3:SetCondition(c101271002.indcon)
    e3:SetOperation(c101271002.indop)
    c:RegisterEffect(e3)
end
--1번 효과 구현
function c101271002.mfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x642)
end
function c101271002.exmfilter(c)
    return c:IsLocation(LOCATION_HAND) and c:IsCode(101271002)
end
function c101271002.matval(e,lc,mg,c,tp)
    if not lc:IsSetCard(0x642) then return false,nil end
    return true,not mg or mg:IsExists(c101271002.mfilter,1,nil) and not mg:IsExists(c101271002.exmfilter,1,nil)
end
--2번 효과 구현
function c101271002.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c101271002.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c101271002.seqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetSequence()~=2
end
function c101271002.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dd=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
	if dd~=nil then return false end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101271002.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101271002.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101271000,1))
	Duel.SelectTarget(tp,c101271002.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101271002.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 and tc:GetSequence() ~= 2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(tc,2)
end
--3번 효과 구현
function c101271002.indcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return r==REASON_LINK and c:GetReasonCard():IsSetCard(0x642)
end
function c101271002.indop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(101271002,1))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c101271002.indval)
    e1:SetOwnerPlayer(ep)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    rc:RegisterEffect(e1,true)
end
function c101271002.indval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end