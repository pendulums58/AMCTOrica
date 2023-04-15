--별빛의 하늘계단
function c101214308.initial_effect(c)
	c:SetUniqueOnField(1,0,101214308)	
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--카운터 적립
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c101214308.cop)
	c:RegisterEffect(e2)
	--레벨 상승
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c101214308.lvcost)
	e3:SetTarget(c101214308.lvtg)
	e3:SetOperation(c101214308.lvop)
	c:RegisterEffect(e3)
	--저는원드로도둑이에요
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(2)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCost(c101214308.drcost)
	e4:SetCondition(c101214308.drcon)
	e4:SetTarget(c101214308.drtg)
	e4:SetOperation(c101214308.drop)
	c:RegisterEffect(e4)
end
function c101214308.cop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101214308.chk,nil,tp)
	if g:GetCount()>0 then
		local ct=g:GetSum(Card.GetPreviousLevelOnField)
		if ct>0 then
			e:GetHandler():AddCounter(0x1324,ct)
		end
	end
end
function c101214308.chk(c,tp)
	return c:IsSetCard(0xef5) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
end
function c101214308.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetCounter(0x1324)>0 end
	local mct=c:GetCounter(0x1324)
	if mct>12 then mct=12 end
	local ct=Duel.AnnounceLevel(tp,1,mct)
	if ct>0 then
		e:SetLabel(ct)
		c:RemoveCounter(0x1324,ct,REASON_COST)
	else
		e:SetLabel(0)
	end
end
function c101214308.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101214308.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101214308.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tc=Duel.SelectTarget(tp,c101214308.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101214308.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c101214308.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=e:GetLabel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)	
	end
end
function c101214308.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetCounter(0x1324)>11 end
	c:RemoveCounter(tp,0x1324,12,REASON_COST)
end
function c101214308.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tg~=e:GetHandler() and tg:IsSummonType(SUMMON_TYPE_SYNCHRO)
		and tg:IsSetCard(0xef5)
end
function c101214308.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101214308.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
