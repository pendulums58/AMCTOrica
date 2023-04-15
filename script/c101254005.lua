--히스즈무 #이스트 스타일
function c101254005.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101254005)
	e1:SetTarget(c101254005.target1)
	c:RegisterEffect(e1)
	--특소 반응
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101254005,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101254005.rmcon)
	e2:SetTarget(c101254005.rmtg)
	e2:SetOperation(c101254005.rmop)
	c:RegisterEffect(e2)
	--덱에서 발동
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetCountLimit(1,101254105)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101254005.condition)
	e3:SetTarget(c101254005.target)
	e3:SetOperation(c101254005.operation)
	c:RegisterEffect(e3)	
end
function c101254005.thfilter(c)
	return c:IsSetCard(0x626) and c:IsAbleToHand()
end
function c101254005.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101254005.thfilter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c101254005.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(101254005,0)) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c101254005.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c101254005.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c101254005.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAbleToHand() then
		if aux.NecroValleyNegateCheck(tc) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c101254005.cfilter(c)
	return not c:IsSummonLocation(LOCATION_HAND) and c:IsAbleToRemove()
end
function c101254005.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101254005.cfilter,1,nil)
end
function c101254005.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c101254005.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=eg:Filter(c101254005.cfilter,nil)
	local tc=g:GetFirst()
	while tc do
		tc:CreateEffectRelation(e)
		tc=g:GetNext()
	end	
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)	
end
function c101254005.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c101254005.cfilter,nil)
	local tc=g:GetFirst()
	local ct=0
	while tc do
		if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		ct=ct+1
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetLabelObject(tc)
			e3:SetCountLimit(1)
			e3:SetCondition(c101254005.retcon)
			e3:SetOperation(c101254005.retop)
			if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END then
				e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
				e3:SetValue(Duel.GetTurnCount())
				tc:RegisterFlagEffect(101254005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,2)
			else
				e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				e3:SetValue(0)
				tc:RegisterFlagEffect(101254005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
			end
			Duel.RegisterEffect(e3,tp)
		end	
		tc=g:GetNext()
	end
	if ct>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c101254005.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetTurnCount()~=e:GetLabel()
end
function c101254005.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,0,REASON_EFFECT+REASON_RETURN)
	e:Reset()
end
function c101254005.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x626)
end
function c101254005.actfilter(c)
	return c:IsCode(101254005) and c:GetActivateEffect():IsActivatable(c:GetControler())
end
function c101254005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101254005.actfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c101254005.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	
	local tc=Duel.GetMatchingGroup(c101254005.actfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil):GetFirst()
	local te=tc:GetActivateEffect()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	if te:IsActivatable(tp) and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		tc:CancelToGrave(false)
		if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tg=g:GetFirst()
		while tg do
			tg:CreateEffectRelation(te)
			tg=g:GetNext()
		end
		if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		tg=g:GetFirst()
		while tg do
			tg:ReleaseEffectRelation(te)
			tg=g:GetNext()
		end
	end
end
