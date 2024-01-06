--시간을 새기는 딜레탕트
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--패 발동 가능
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)		
end
function s.handcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(Card.IsOwner,tp,0,LOCATION_MZONE,1,nil,tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		if g:GetFirst():IsLocation(LOCATION_GRAVE) then
			Duel.Remove(g,POS_FACEUP,REASON_COST)
		else
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tp,tc:GetFirst():GetLocation())
end
function s.cfilter(c)
	return (c:IsCode(87902575) or c:IsCode(50292967)) and ((c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()) or c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD))
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(s.chk,tp,LOCATION_MZONE,0,1,nil) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetOperation(s.thop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabel(tp)
		tc:RegisterEffect(e1)
	end
end
function s.chk(c)
	return c:IsSetCard(SETCARD_DILETANT) or c:IsCode(111331100)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	Duel.SendtoHand(e:GetHandler(),p,REASON_EFFECT)
end