--만물의 영장
function c101273005.initial_effect(c)
    --액세스 소환
	cyan.AddAccessProcedure(c,c101273005.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--소환 무효 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetCondition(c101273005.effcon)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--gains atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(c101273005.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101273005,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101273005)
	e4:SetCondition(c101273005.drcon)
	e4:SetTarget(c101273005.drtg)
	e4:SetOperation(c101273005.drop)
	c:RegisterEffect(e4)
	--무효화
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101273005,0))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e5:SetCountLimit(1,101274005)
	e5:SetCondition(c101273005.spcon)
	e5:SetTarget(c101273005.sptg)
	e5:SetOperation(c101273005.spop)
	c:RegisterEffect(e5)
	--전부 덱으로 돌린다
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(101273005,2))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,101275005)
	e6:SetCondition(c101273005.drcon2)
	e6:SetTarget(c101273005.tdtg)
	e6:SetOperation(c101273005.tdop)
	c:RegisterEffect(e6)	
end
function c101273005.afil1(c)
	return c:IsSetCard(0x645)
end
function c101273005.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c101273005.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x645)
end
function c101273005.atkfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x645)
end
function c101273005.atkval(e)
	return Duel.GetMatchingGroupCount(c101273005.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*200
end
function c101273005.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101273005.filter1,tp,LOCATION_GRAVE,0,7,nil)
end
function c101273005.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101273005.drop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c101273005.filter1,tp,LOCATION_GRAVE,0,7,nil) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101273005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101273005.filter1,tp,LOCATION_GRAVE,0,12,nil)
end
function c101273005.filter3(c,e,tp)
	return aux.disfilter1(c) and aux.NegateEffectMonsterFilter(c)
end
function c101273005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local pr=e:GetHandler()
	if chkc then return chkc:IsOnField() and c101273005.filter3(chkc,pr) end
	if chk==0 then return Duel.IsExistingTarget(c101273005.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,pr) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101273005.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,pr)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c101273005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)	
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c101273005.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101273005.filter1,tp,LOCATION_GRAVE,0,20,nil)
end
function c101273005.tdfilter(c)
	return (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c101273005.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c101273005.tdfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetChainLimit(aux.FALSE)
end
function c101273005.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101273005.tdfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,aux.ExceptThisCard(e))
	if aux.NecroValleyNegateCheck(g) then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end

