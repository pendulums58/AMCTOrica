--두 번 유혹하는 심연
function c101223123.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c101223123.con)
	e1:SetTarget(c101223123.tg)
	e1:SetOperation(c101223123.op)
	c:RegisterEffect(e1)
	--묘지 효과
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101223123.gtg)
	e2:SetOperation(c101223123.gop)
	c:RegisterEffect(e2)
end
function c101223123.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_DUAL)
end
function c101223123.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c101223123.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	local tc=Duel.SelectTarget(tp,c101223123.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101223123.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SelectYesNo(1-tp,aux.Stringid(101223123,0)) and Duel.SendtoGrave(tc,REASON_RULE)~=0 then
			Duel.NegateEffect(0)
		else
			local g=Duel.SelectMatchingCard(tp,c101223123.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,true,nil)
					and Duel.SelectYesNo(tp,aux.Stringid(101223123,1)) then
					local ns=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,true,nil)
					if ns:GetCount()>0 then
						Duel.Summon(tp,ns:GetFirst(),true,nil)
					end
				end
			end
		end
	end
end
function c101223123.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_DUAL)
end
function c101223123.gtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local tc=Duel.SelectTarget(tp,c101223123.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c101223123.gop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SelectYesNo(1-tp,aux.Stringid(101223123,0)) and Duel.SendtoGrave(tc,REASON_RULE)~=0 then
			Duel.NegateEffect(0)
		else
			if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,true,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(101223123,1)) then
				local ns=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,true,nil)
				if ns:GetCount()>0 then
					Duel.Summon(tp,ns:GetFirst(),true,nil)
				end
			end
		end
	end
end