--창성유물『개벽성개』
function c101248014.initial_effect(c)
	--싱크로
	aux.AddSynchroMixProcedure(c,c101248014.matfilter1,nil,nil,aux.NonTuner(aux.TRUE),1,99)
	c:EnableReviveLimit()
	--공 증가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(c101248014.val)
	c:RegisterEffect(e1)
	--바운스
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101248014.thcost)
	e2:SetTarget(c101248014.thtg)
	e2:SetOperation(c101248014.thop)
	c:RegisterEffect(e2)
end
function c101248014.matfilter1(c)
	return c:GetLevel()==11 and (c:IsType(TYPE_TUNER) or c:IsSetCard(0x620))
end
function c101248014.val(e,c)
	local lv=c:GetLevel()
	if c:GetRank()>0 then lv=c:GetRank() end
	return lv*100
end
function c101248014.costfilter(c)
	return c:IsSetCard(0x622) and c:IsAbleToRemoveAsCost()
end
function c101248014.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101248014.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101248014.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101248014.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101248014.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
