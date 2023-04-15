--별빛의 하늘계단
function c101214010.initial_effect(c)
	--필드에 발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--LRM에 의한 소환시 드로우
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101214010.drcon)
	e2:SetTarget(c101214010.drtg)
	e2:SetOperation(c101214010.drop)
	c:RegisterEffect(e2)
	--프리체인 레벨 증가
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101214010,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetTarget(c101214010.thtg)
	e3:SetOperation(c101214010.thop)
	c:RegisterEffect(e3)
	--특수 소환
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(101214010,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,101214010)
	e4:SetCost(c101214010.cost1)
	e4:SetCondition(c101214010.condition)
	e4:SetTarget(c101214010.sptg)
	e4:SetOperation(c101214010.spop)
	c:RegisterEffect(e4)
end
function c101214010.drfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c101214010.drcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return eg:IsExists(c101214010.drfilter,1,nil) and rc:IsSetCard(0x9ec7)
end
function c101214010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101214010.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101214010.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c101214010.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101214010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101214010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101214010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101214010.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local lv=Duel.SelectOption(tp,aux.Stringid(101214010,2),aux.Stringid(101214010,3),aux.Stringid(101214010,4))
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(lv+1)
		tc:RegisterEffect(e1)
	end
end
function c101214010.cfilter1(c)
	return c:IsFaceup() and c:GetLevel()>29 and c:IsType(TYPE_SYNCHRO)
end
function c101214010.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101214010.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c101214010.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101214010.spfilter(c,e,tp)
	return c:IsSetCard(0xef5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101214010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c101214010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsExistingMatchingCard(c101214010.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101214010.spfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc=g:GetNext()
	end
end
