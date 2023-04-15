--무장전선
function c101234026.initial_effect(c)
	--필드 발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--드로우
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101234026,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c101234026.cost)
	e2:SetTarget(c101234026.target)
	e2:SetOperation(c101234026.activate)
	c:RegisterEffect(e2)
	--장착
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101234026,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c101234026.eqtg)
	e3:SetOperation(c101234026.eqop)
	c:RegisterEffect(e3)
	--회수
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101234026,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c101234026.thtg)
	e4:SetOperation(c101234026.thop)
	c:RegisterEffect(e4)
end
function c101234026.filter(c)
	return c:IsSetCard(0x611) and c:IsDiscardable()
end
function c101234026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101234026.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101234026.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c101234026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101234026.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101234026.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
end
function c101234026.filter2(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
end
function c101234026.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101234026.filter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101234026.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c101234026.filter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c101234026.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101234026.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not tc:IsControler(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	local g=Duel.SelectMatchingCard(tp,c101234026.filter2,tp,LOCATION_HAND,0,1,1,nil)
	local g1=g:GetFirst()
	Duel.Equip(tp,g1,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c101234026.eqlimit)
	e1:SetLabelObject(tc)
	g1:RegisterEffect(e1) 
end
function c101234026.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c101234026.filter3(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_EQUIP)
end
function c101234026.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101234026.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101234026.filter3,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.SelectTarget(tp,c101234026.filter3,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101234026.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end