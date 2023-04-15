--스토리텔러-문득 스쳐간 발단
function c103550004.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,103550004)
	e1:SetOperation(c103550004.activate)
	c:RegisterEffect(e1)
	--효과 부여
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103550004,2))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c103550004.drtg)
	e2:SetOperation(c103550004.drop)
	c:RegisterEffect(e2)	
end
function c103550004.filter(c)
	return c:IsSetCard(0x64a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c103550004.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c103550004.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(103550004,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c103550004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c103550004.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
		if Duel.IsExistingMatchingCard(c103550004.disfilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(103550004,1)) then
			local g=Duel.SelectMatchingCard(tp,c103550004.disfilter,tp,LOCATION_HAND,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
			end
		else
			local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0,nil)
			local sg=g1:RandomSelect(tp,2)
			Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		end
	end
end
function c103550004.disfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsDiscardable()	
		and c:IsSetCard(0x64a)
end