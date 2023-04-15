--CR(크로니클 레플리카)-이별과 절망의 시련
function c101269904.initial_effect(c)
	--몬스터 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101269904)
	e1:SetCost(cyan.selfdiscost)
	e1:SetTarget(c101269904.thtg)
	e1:SetOperation(c101269904.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101269904,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c101269904.opcon)
	e2:SetTarget(c101269904.optg)
	e2:SetOperation(c101269904.opop)
	c:RegisterEffect(e2)
end
function c101269904.tgfilter(c,tp)
	return c:IsSetCard(0x641) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c101269904.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c101269904.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101269904.tgfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,c101269904.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)	
end
function c101269904.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c101269904.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and 
	tc:IsRelateToEffect(e) and tc:GetCode()~=tg:GetCode() then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c101269904.thfilter(c)
	return c:IsSetCard(0x641) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c101269904.opcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=1
		and Duel.GetDrawCount(tp)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
end
function c101269904.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101269904.opop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end