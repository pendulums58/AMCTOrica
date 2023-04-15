--월하자박 - 초승달에 꿰여
function c101271000.initial_effect(c)
	--일소 성공 시 덱 6장 넘기고 월하 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101271000)
	e1:SetTarget(c101271000.sutg)
	e1:SetOperation(c101271000.suop)
	c:RegisterEffect(e1)
	--묘지의 이 카드를 덱으로 되돌리고 월하 몬스터를 이동
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101271000,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,101271100)
	e2:SetCondition(c101271000.seqcon)
	e2:SetCost(c101271000.seqcost)
	e2:SetTarget(c101271000.seqtg)
	e2:SetOperation(c101271000.seqop)
	c:RegisterEffect(e2)
	--링크 소재로 쓰이면 1드로
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,101271901)
	e3:SetCondition(c101271000.drcon)
	e3:SetTarget(c101271000.drtg)
	e3:SetOperation(c101271000.drop)
	c:RegisterEffect(e3)
end
--1번 구현
function c101271000.sufilter(c)
	return c:IsSetCard(0x642) and c:IsAbleToHand()
end
function c101271000.sutg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c101271000.suop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.ConfirmDecktop(tp,6)
	local g=Duel.GetDecktopGroup(tp,6)
	if g:GetCount()>0 then
		if g:IsExists(c101271000.sufilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101271000,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c101271000.sufilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
	end
end
--2번 구현
function c101271000.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c101271000.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c101271000.seqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetSequence()~=0
end
function c101271000.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dd=Duel.GetFieldCard(tp,LOCATION_MZONE,0)
	if dd~=nil then return false end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101271000.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101271000.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101271000,1))
	Duel.SelectTarget(tp,c101271000.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c101271000.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 and tc:GetSequence() ~= 0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(tc,0)
end
--3번 구현
function c101271000.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x642)
end
function c101271000.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101271000.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end