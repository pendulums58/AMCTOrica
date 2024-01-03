--의례의 워울프소녀
function c101270001.initial_effect(c)
	--상대 효과 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101270001.imcon)
	e1:SetValue(c101270001.efilter)
	c:RegisterEffect(e1)	
	--축적시 발동
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_AMASS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101270001)
	e2:SetCondition(c101270001.spcon)
	e2:SetTarget(c101270001.sptg)
	e2:SetOperation(c101270001.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_HAND)
	c:RegisterEffect(e3)
	--서치
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DRAW)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCondition(c101270001.regcon)
	e4:SetTarget(c101270001.regtg)
	e4:SetOperation(c101270001.regop)
	c:RegisterEffect(e4)
end
function c101270001.imcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetTurnPlayer()==1-tp
end
function c101270001.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c101270001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c101270001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c101270001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
function c101270001.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetCurrentPhase()==PHASE_DRAW and r==REASON_RULE and c:IsAbleToDeck()	
		and eg:IsExists(Card.IsAbleToDeck,1,nil) and ep==tp
end
function c101270001.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and eg:IsExists(Card.IsAbleToDeck,1,nil)
		 and Duel.IsExistingMatchingCard(c101270001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local tc=eg:FilterSelect(tp,Card.IsAbleToDeck,1,1,nil)
	Duel.ConfirmCards(1-tp,tc)
	local g=Group.CreateGroup()
	g:AddCard(c)
	g:AddCard(tc)
	e:SetLabelObject(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101270001.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if not g:GetCount()==2 then return end
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local g1=Duel.SelectMatchingCard(tp,c101270001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
		end
	end
end
function c101270001.thfilter(c)
	return c:IsAbleToHand() and c.AmassEffect==true
end