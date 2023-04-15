--혼합음료 브랜티니
function c101236017.initial_effect(c)
	--소재 불가 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYHCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_ACCESS_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_PAIRING_MATERIAL)
	c:RegisterEffect(e6)
	--2번 효과
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BLEND)
	e7:SetTarget(c101236017.blendtg)
	e7:SetOperation(c101236017.blendop)
	c:RegisterEffect(e7)
	--3번 효과
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_TO_HAND)
	e8:SetCondition(c101236017.condition)
	e8:SetTarget(c101236017.target)
	e8:SetOperation(c101236017.operation)
	c:RegisterEffect(e8)
end
function c101236017.filter1(c)
	return (c:IsSetCard(0x659) or c:IsSetCard(0x658) or c:IsCode(101236009)) and c:IsAbleToHand()
end
function c101236017.blendtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101236017.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101236017.blendop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101236017.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101236017.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c101236017.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101236017.cfilter,1,nil,1-tp)
end
function c101236017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tc=eg:GetFirst()
		while tc do
			local g=Duel.GetMatchingGroup(c101236017.thfilter,tp,0,LOCATION_DECK,nil,tc)
			if g:GetClassCount(Card.GetCode,nil)>=2 then return true end
			tc=eg:GetNext()
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function c101236017.thfilter(c,tc)
	return c:IsAbleToHand() and not c:IsCode(tc:GetCode()) and c:IsSetCardList(Duel.ReadCard(tc,CARDDATA_SETCODE)) 
end
function c101236017.tgfilter(c,tp)
	local g=Duel.GetMatchingGroup(c101236017.thfilter,tp,0,LOCATION_DECK,nil,c)
	return g:GetClassCount(Card.GetCode,nil)>=2
end
function c101236017.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=nil
	if eg:GetCount()>1 then
		tc=eg:FilterSelect(1-tp,c101236017.tgfilter,1,1,nil,tp):GetFirst()
	else
		tc=eg:GetFirst()
	end
	if tc~=nil and Duel.Destroy(c,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c101236017.thfilter,tp,0,LOCATION_DECK,nil,tc)
		if g:GetClassCount(Card.GetCode,nil)>=2 then
			local g1=g:SelectSubGroup(1-tp,aux.dncheck,false,2,2)
			g1:AddCard(tc)
			if g1:GetCount()==3 then
				Duel.ConfirmCards(tp,g1)
				local g2=g1:Select(tp,1,1,nil)
				local tc1=g2:GetFirst()
				if tc1~=tc and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) then
					Duel.SendtoHand(tc1,nil,REASON_EFFECT)
				end
				Duel.ShuffleHand(1-tp)
			end
		end
	end
end