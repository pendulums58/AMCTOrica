--월하연월 - 은은하게 빛나는 달 
function c101271003.initial_effect(c)
	--이 카드가 묘지에 존재하고 자신 필드에 몬스터가 없을 경우, 이 카드를 묘지에서 특수 소환한다.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69610326,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101271003)
	e1:SetCondition(c101271003.spcon)
	e1:SetTarget(c101271003.sptg)
	e1:SetOperation(c101271003.spop)
	c:RegisterEffect(e1)
	--묘지의 이 카드를 덱으로 되돌리고 몬스터를 이동
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101271000,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,101271103)
	e2:SetCondition(c101271003.seqcon)
	e2:SetCost(c101271003.seqcost)
	e2:SetTarget(c101271003.seqtg)
	e2:SetOperation(c101271003.seqop)
	c:RegisterEffect(e2)
	--링크소재로 보내졌을 경우 그 링크 몬스터에게 공격력 500
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67586735,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c101271003.atkcon)
	e3:SetOperation(c101271003.atkop)
	c:RegisterEffect(e3)
end
--1번 효과 구현
function c101271003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c101271003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101271003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--2번 효과 구현
function c101271003.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c101271003.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c101271003.seqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetSequence()~=3
end
function c101271003.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dd=Duel.GetFieldCard(tp,LOCATION_MZONE,3)
	if dd~=nil then return false end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101271003.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101271003.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101271000,1))
	Duel.SelectTarget(tp,c101271003.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101271003.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 and tc:GetSequence() ~= 3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(tc,3)
end
--3번 효과 구현
function c101271003.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x642)
end
function c101271003.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if rc:IsFaceup() and rc:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
	end
end