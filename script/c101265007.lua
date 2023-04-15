--플래그마타의 자취
function c101265007.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101265007,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101265007)
	e1:SetCost(c101265007.cost)
	e1:SetTarget(c101265007.thtg)
	e1:SetOperation(c101265007.thop)
	c:RegisterEffect(e1)
	--공뻥
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101265007.target)
	e2:SetOperation(c101265007.activate)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101265007,ACTIVITY_SPSUMMON,c101265007.counterfilter)
end
function c101265007.counterfilter(c)
	return c:IsSetCard(0x633)
end
function c101265007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101265007,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101265007.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101265007.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x633)
end
function c101265007.ctfilter(c)
	return c:IsSetCard(0x633) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101265007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<8 then return false end
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,LOCATION_DECK)
end
function c101265007.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,7)
	local g=Duel.GetDecktopGroup(tp,7)
	if g:GetCount()>0 then
		local tg=g:Filter(c101265007.ctfilter,nil)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,7,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			if sg:GetCount()<3 and Duel.SelectYesNo(tp,aux.Stringid(101265000,0)) then
				Duel.DecreaseMaxHandSize(e:GetHandler(),tp,1)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
function c101265007.filter(c)
	return c:GetLink()>2 and c:IsSetCard(0x633) and c:IsFaceup()
end
function c101265007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101265007.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101265007.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101265007.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101265007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
	end
end
