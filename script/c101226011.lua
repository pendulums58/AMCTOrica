--신살마녀 비술의 장
function c101226011.initial_effect(c)
	c:SetUniqueOnField(1,0,101226011)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--공격력 상승
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101226011.atkcon)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--묘지 회수 및 파괴
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c101226011.thtg)
	e3:SetOperation(c101226011.thop)
	c:RegisterEffect(e3)	
end
function c101226011.atkcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c101226011.filter1(c)
	return c:IsSetCard(0x612) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101226011.atkfilter(c)
	return c:GetAttack()>=1500
end
function c101226011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101226011.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101226011.atkfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c101226011.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101226011.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	if g:GetFirst():GetAttack()>=2000 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c101226011.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetAttack()>=1500 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101226011.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end	
		if tc:GetAttack()>=2000 then
			Duel.Destroy(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end