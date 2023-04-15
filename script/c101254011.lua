--요아소비 #이스트 스타일
function c101254011.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c101254011.thtg)
	e2:SetOperation(c101254011.thop)
	c:RegisterEffect(e2)
	--상대 엑트 제외
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(c101254011.rmcon)
	e3:SetCountLimit(1)
	e3:SetTarget(c101254011.rmtg)
	e3:SetOperation(c101254011.rmop)
	c:RegisterEffect(e3)
	--파괴 내성
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c101254011.desreptg)
	c:RegisterEffect(e4)	
end
function c101254011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101254011.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101254011.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c101254011.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,0,LOCATION_DECK)	
end
function c101254011.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101254011.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttack())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c101254011.thfilter(c)
	local tp=c:GetControler()
	return c:IsSetCard(0x626) and Duel.IsExistingMatchingCard(c101254011.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetAttack())
end
function c101254011.thfilter2(c,atk)
	return c:IsSetCard(0x626) and c:IsType(TYPE_MONSTER) and c:GetAttack()<atk
end
function c101254011.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c101254011.rmchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101254011.rmchk(c)
	return c:GetSequence()>=5 and c:IsSetCard(0x626)
end
function c101254011.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101254011.rmfilter,tp,0,LOCATION_EXTRA,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,0,LOCATION_EXTRA)
end
function c101254011.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101254011.rmfilter,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()<3 then return end
	local g1=g:RandomSelect(tp,3)
	if g1:GetCount()==3 then
		local tc=g1:GetFirst()
		while tc do
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabelObject(tc)
				e1:SetCondition(c101254011.retcon)
				e1:SetOperation(c101254011.retop)
				if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
					e1:SetLabel(0)
				else
					e1:SetLabel(Duel.GetTurnCount())
				end
				Duel.RegisterEffect(e1,tp)
			end
			tc=g1:GetNext()
		end
	end
end
function c101254011.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c101254011.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel()
end
function c101254011.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,0,REASON_EFFECT+REASON_RETURN)
	e:Reset()
end
function c101254011.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE)
		and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
		return true
	else return false end
end
