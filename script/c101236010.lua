--Va-11 Hall-A
function c101236010.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- --1번 효과
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetCategory(CATEGORY_DRAW)
	-- e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	-- e2:SetProperty(EFFECT_FLAG_DELAY)
	-- e2:SetCode(EVENT_CHAINING)
	-- e2:SetRange(LOCATION_FZONE)
	-- e2:SetCountLimit(2)
	-- e2:SetTarget(c101236010.drtg)
	-- e2:SetOperation(c101236010.drop)
	-- c:RegisterEffect(e2)
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c101236010.acop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--3번 효과
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c101236010.cmcost)
	e4:SetTarget(c101236010.cmtg)
	e4:SetOperation(c101236010.cmop)
	c:RegisterEffect(e4)
end
-- function c101236010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- local test=re:GetCode()
	-- if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and rp==tp and re:GetCode()==EVENT_BLEND end
	-- Duel.SetTargetPlayer(tp)
	-- Duel.SetTargetParam(1)
	-- Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
-- end
-- function c101236010.drop(e,tp,eg,ep,ev,re,r,rp)
	-- local c=e:GetHandler()
	-- local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	-- Duel.Draw(p,d,REASON_EFFECT)
-- end
function c101236010.acfilter(c)
	return c:IsSetCard(0x658) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c101236010.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c101236010.acfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x1326,ct,true)
	end
end
function c101236010.cmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1326,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1326,1,REASON_COST)
end
function c101236010.cmfilter(c)
	return c:IsFaceup() and c:IsCode(101236009)
end
function c101236010.cmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101236010.cmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101236010.cmfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101236010.cmfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101236010.cmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	yipi.SelectChemical(tp,tc)
end