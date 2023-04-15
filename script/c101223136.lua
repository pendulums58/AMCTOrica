--흑사의 시선
function c101223136.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101223136.cost)
	e1:SetTarget(c101223136.target)
	e1:SetOperation(c101223136.operation)
	c:RegisterEffect(e1)
	--공포) 저스트서치의 극한이 있다?
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	cyan.JustSearch(e2,LOCATION_GRAVE,Card.IsType,TYPE_XYZ)
	c:RegisterEffect(e2)
end
function c101223136.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223136.filter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101223136.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local g1=Duel.GetMatchingGroup(c101223136.filter1,tp,LOCATION_EXTRA,0,nil,tc:GetCode())
		Duel.Remove(g1,POS_FACEUP,REASON_COST)
		local ct=g1:GetSum(Card.GetLevel,nil)
		e:SetLabel(ct)
	end
end
function c101223136.filter(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c101223136.filter1(c,code)
	return c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost() and c:IsCode(code)
end
function c101223136.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	local g=Duel.SelectMatchingCard(tp,c101223136.chk,tp,0,LOCATION_HAND,1,e:GetLabel(),nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(g,tp)
		local g1=g:FilterSelect(tp,c101223136.chk1,1,1,nil,e:GetLabel())
		if g1:GetCount()>0 then
			local tc=g1:GetFirst()
			Duel.HintSelection(tc)
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.SelectYesNo(1-tp,aux.Stringid(101223136,0)) then
				Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
			else
				if not Duel.SelectYesNo(tp,aux.Stringid(101223136,1)) then return end
				local g2=Duel.SelectMatchingCard(tp,c101223136.chk2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
				if g2:GetCount()>0 then
					Duel.SendtoHand(g2,nil,REASON_EFFECT)
					Duel.ConfirmCards(g2,1-tp)
				end
			end
		end
	end
end
function c101223136.chk(c)
	return not c:IsPublic()
end
function c101223136.chk1(c,ct)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(ct)
end
function c101223136.chk2(c,code)
	return c:IsCode(code) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end