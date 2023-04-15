--시계탑을 꿰뚫다
function c101213329.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101213329.target)
	e1:SetOperation(c101213329.activate)
	c:RegisterEffect(e1)
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101213329,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c101213329.condition)
	e2:SetTarget(c101213329.target1)
	e2:SetOperation(c101213329.operation1)
	c:RegisterEffect(e2)
end
function c101213329.tgfilter(c)
	return c:IsCode(CARD_CLOCKTOWER) or (c:GetSummonLocation()==LOCATION_EXTRA and c:IsSetCard(0x60a))
end
function c101213329.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c101213329.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101213329.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local g1=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,g1:GetCount(),0,0)	
end
function c101213329.filter(c,tp)
	return c:IsCode(75041269) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c101213329.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
			local tc=g:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				tc=g:GetNext()
			end
			if Duel.IsExistingMatchingCard(c101213329.actfilter,tp,LOCATION_MZONE,0,1,nil)
				and Duel.IsExistingMatchingCard(c101213329.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
				and Duel.SelectYesNo(tp,aux.Stringid(101213329,0)) then
					local g1=Duel.SelectMatchingCard(tp,c101213329.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
				local tc1=g1:GetFirst()
				if tc1 then
					local te=tc1:GetActivateEffect()
					local b2=te:IsActivatable(tp,true,true)
					local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
					if fc then
						Duel.SendtoGrave(fc,REASON_RULE)
						Duel.BreakEffect()
					end
					Duel.MoveToField(tc1,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
					te:UseCountLimit(tp,1,true)
					local tep=tc1:GetControler()
					local cost=te:GetCost()
					if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
					tc1:AddCounter(0x1b,4)
				end
			end
		end
	end
end
function c101213329.actfilter(c)
	return c:IsType(TYPE_ACCESS) and c:IsSetCard(0x60a)
end
function c101213329.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function c101213329.filter1(c)
	return (c:IsCode(101213318) or (c:IsSetCard(0x60a) and c:IsType(TYPE_MONSTER))) and c:IsAbleToHand()
end
function c101213329.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213329.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101213329.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101213329.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
