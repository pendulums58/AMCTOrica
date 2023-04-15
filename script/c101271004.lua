--월하초옹 - 그믐달에 안기며
function c101271004.initial_effect(c)
	--이 카드가 5번 메인 몹 존에 있는 한 내 필드의 월하는 릴리스 안됌
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c101271004.relcon)
	e1:SetTarget(c101271004.rellimit)
	c:RegisterEffect(e1)
	--묘지의 이 카드를 덱으로 되돌리고 몬스터를 이동
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101271000,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,101271104)
	e2:SetCondition(c101271004.seqcon)
	e2:SetCost(c101271004.seqcost)
	e2:SetTarget(c101271004.seqtg)
	e2:SetOperation(c101271004.seqop)
	c:RegisterEffect(e2)
	--링크 소재가 되었을 때 상대 몹 존 하나 막음
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,101271914)
	e3:SetCondition(c101271004.grcon)
	e3:SetOperation(c101271004.grop)
	c:RegisterEffect(e3)
end
--1번 효과 구현
function c101271004.relcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetSequence()==4
end
function c101271004.rellimit(e,c,tp,sumtp)
	return c:IsSetCard(0x642)
end
--2번 효과 구현
function c101271004.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c101271004.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c101271004.seqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetSequence()~=4
end
function c101271004.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dd=Duel.GetFieldCard(tp,LOCATION_MZONE,4)
	if dd~=nil then return false end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101271004.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101271004.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101271000,1))
	Duel.SelectTarget(tp,c101271004.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101271004.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 and tc:GetSequence() ~= 4 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(tc,4)
end
--3번 효과 구현
function c101271004.grcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK --and c:GetReasonCard():IsSetCard(0x642)
end
function c101271004.grop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(101271004,0)) then
		Duel.BreakEffect()
		local zone=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
		if tp==1 then
			zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetValue(zone)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
