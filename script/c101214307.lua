--하늘에의 도움닫기
function c101214307.initial_effect(c)
	--천기좋아천기의날만들기
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101214307)
	e1:SetOperation(c101214307.activate)
	c:RegisterEffect(e1)	
	--카운터 적립
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(c101214307.ctop)
	c:RegisterEffect(e2)
	--카운터 이동
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c101214307.lvtg)
	e4:SetOperation(c101214307.lvop)
	c:RegisterEffect(e4)
end
function c101214307.filter(c)
	return c:IsSetCard(0xef5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101214307.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101214307.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101214307,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101214307.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xef5) and c:IsControler(tp)
end
function c101214307.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c101214307.ctfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0x1324,1)
	end
end
function c101214307.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101214307.tgfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c101214307.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():GetCounter(0x1324)>0 end
	local tc=Duel.SelectTarget(tp,c101214307.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101214307.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:GetCounter(0x1324)>0 then
		local ct=c:GetCounter(0x1324)
		c:RemoveCounter(tp,0x1324,c:GetCounter(0x1324),REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c101214307.tgfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsSetCard(0xef5)
end