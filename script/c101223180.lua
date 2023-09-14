--타임메이커즈 보이드
local s,id=GetID()
function s.initial_effect(c)
	--서치 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(cyan.selfdiscost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--덱 맨 위에 놓기
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(s.rvop)
	c:RegisterEffect(e2)
end
s.listed_names={id}
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)	
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			local g1=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
			if g1:GetCount()>0 then
				Duel.SendtoHand(g1,nil,REASON_EFFECT)
				Duel.ConfirmCards(g1,1-tp)
			end
		end
	end
end
function s.rmfilter(c,tp)
	return c:IsAbleToRemove() and (c:IsAttack(1400) or c:IsDefense(1400))
		and Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,c,c:GetSetCard())
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c,c)
end
function s.chkfilter(c,sc)
	return c:IsSetCardList(sc) and c:ListsCode(id)
end
function s.thfilter(c,sc)
	return c:IsSetCardList(sc) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.rvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(s.chkfilter1,1,nil) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		if c:GetFlagEffect(id)==3 then
			if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				c:ResetFlagEffect(id)
				Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
			else
				c:ResetFlagEffect(id)
			end
		end
	end
end
function s.chkfilter1(c)
	return c:ListsCode(id)
end