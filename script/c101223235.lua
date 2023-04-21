--해방하는 의지
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(aux.bfgcost)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.kfilter,tp,LOCATION_HAND,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectMatchingCard(tp,s.kfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	e:SetLabelObject(g)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local g1=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,g)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)
		local tc=g
		local code=tc:GetOriginalCode()
		local mt=_G["c"..code]
		local ct=0
		local te=e
		while mt.eff_ct[tc][ct] do
			local e1=mt.eff_ct[tc][ct]
			local ty=e1:GetCategory()
			if bit.band(ty,CATEGORY_SPECIAL_SUMMON)==CATEGORY_SPECIAL_SUMMON then
				te=e1
			end
			ct=ct+1
		end		

		local op=te:GetOperation()
		op(te,tp,eg,ep,ev,re,r,rp)
	end
end
function s.kfilter(c,tp)
	return c:IsType(TYPE_KEY) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(g,1-tp)
		end
	end
end
function s.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function s.thfilter(c,tc)
	local sc=c:GetSetCard()
	return c:IsType(TYPE_KEY) and (c:IsRace(tc:GetRace()) or c:IsAttribute(tc:GetAttribute()) or tc:IsSetCardList(sc))
		and c:IsAbleToHand()
end
