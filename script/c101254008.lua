--아카하시 #이스트 스타일
function c101254008.initial_effect(c)
	--제외 + 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101254008)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c101254008.cost)
	e1:SetTarget(c101254008.target)
	e1:SetOperation(c101254008.operation)
	c:RegisterEffect(e1)
	--엑시즈 소재로 한다
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101254008,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,101254008)
	e2:SetCondition(c101254008.tgcon)
	e2:SetTarget(c101254008.tgtg)
	e2:SetOperation(c101254008.tgop)
	c:RegisterEffect(e2)	
end
function c101254008.dfilter(c)
	return c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c101254008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c101254008.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c101254008.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c101254008.rmfilter(c,tp)
	return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c101254008.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c101254008.thfilter(c,tc)
	local ty=0
	if tc:IsType(TYPE_MONSTER) then ty=TYPE_MONSTER end
	if tc:IsType(TYPE_SPELL) then ty=TYPE_SPELL end
	if tc:IsType(TYPE_TRAP) then ty=TYPE_TRAP end	
	return c:IsSetCard(0x626) and c:IsType(ty) and c:IsAbleToHand()
end
function c101254008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and c101254008.rmfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101254008.rmfilter,tp,0,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101254008.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c101254008.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local ty=0	
		local g=Duel.SelectMatchingCard(tp,c101254008.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function c101254008.cfilter(c,tp)
	return c:IsControler(1-tp)
end
function c101254008.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101254008.cfilter,1,nil,tp)
end
function c101254008.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x626) and c:IsType(TYPE_XYZ)
end
function c101254008.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101254008.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101254008.filter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101254008.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c101254008.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
