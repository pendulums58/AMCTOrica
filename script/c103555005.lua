--벚꽃 만개
function c103555005.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,103555005)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c103555005.tg)
	e1:SetOperation(c103555005.op)
	c:RegisterEffect(e1)
	--패발동
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c103555005.handcon)
	c:RegisterEffect(e2)
end
function c103555005.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp)
		and c103555005.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c103555005.tgfilter,tp,0,LOCATION_GRAVE,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,c103555005.tgfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
	if tc:GetFirst():GetExtraType()==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,tp,LOCATION_GRAVE)
end
function c103555005.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		if tc:IsLocation(LOCATION_DECK) then
			local g=Duel.SelectTarget(tp,c103555005.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttack())
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		elseif tc:IsLocation(LOCATION_EXTRA) then
			local token=Duel.CreateToken(tp,tc:GetCode())
			Duel.SendtoDeck(token,nil,2,REASON_EFFECT)
			Duel.ConfirmCards(token,1-tp)
			if token:IsType(TYPE_FUSION) then
				aux.AddFusionProcFunRep(token,aux.FilterBoolFunction(Card.IsFusionSetCard,0x65a),3,false)
			end
			if token:IsType(TYPE_SYNCHRO) then
				aux.AddSynchroProcedure(token,nil,aux.NonTuner(nil),1)
			end
			if token:IsType(TYPE_XYZ) then
				aux.AddXyzProcedure(token,aux.FilterBoolFunction(Card.IsSetCard,0x65a),3,2)
			end			
			if token:IsType(TYPE_ACCESS) then
				cyan.AddAccessProcedure(token,aux.TRUE,aux.TRUE)
			end	
			if token:IsType(TYPE_LINK) then
				aux.AddLinkProcedure(token,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
			end					
			if token:IsType(TYPE_PAIRING) then
				cyan.AddPairingProcedure(token,c103555005.pfilter,c103555005.mfilter,2,2)
			end					
		end
		
	end
end
function c103555005.tgfilter(c,tp)
	return (c:GetExtraType()>0 or Duel.IsExistingMatchingCard(c103555005.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttack())) and (c:IsAbleToDeck() or c:IsAbleToExtra()) and c:IsType(TYPE_MONSTER)
end
function c103555005.thfilter(c,atk)
	return c:IsSetCard(0x65a) and c:IsAbleToHand() and c:IsAttackBelow(atk-1) and c:IsType(TYPE_MONSTER)
end
function c103555005.pfilter(c)
	return c:IsSetCard(0x65a)
end
function c103555005.mfilter(c,pair)
	return c:GetLevel()>pair:GetLevel()
end
function c103555005.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
