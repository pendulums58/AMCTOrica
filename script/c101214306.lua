--스카이워커즈 어드마이어
function c101214306.initial_effect(c)
	--레벨에 따른 효과 적용
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101214306)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101214306.tg)
	e1:SetOperation(c101214306.op)
	c:RegisterEffect(e1)
	--레벨 100
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCountLimit(1,101214406)
	e2:SetCost(c101214306.lvcost)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101214306.lvtg)
	e2:SetOperation(c101214306.lvop)
	c:RegisterEffect(e2)
end
function c101214306.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101214306.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101214306.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local tc=Duel.SelectTarget(tp,c101214306.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if tc:GetFirst():IsLevelAbove(12) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)	
	else
		e:SetCategory(0)
	end
end
function c101214306.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsLevelBelow(11) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(12)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		else
			local g=Duel.SelectMatchingCard(tp,c101214306.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			local tc1=g:GetFirst()
			if not c101214306.thfilter(tc) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				if c101214306.spfilter(tc,e,tp) then
					local op=Duel.SelectOption(tp,aux.Stringid(101214306,0),aux.Stringid(101214306,1))
					if op==0 then
						Duel.SendtoHand(tc,nil,REASON_EFFECT)
					else
						Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
					end
				end
			end
		end
	end
end
function c101214306.tgfilter(c,e,tp)
	if not c:IsSetCard(0xef5) then return false end
	if c:IsLevelBelow(11) then return c:IsLevelAbove(1) end
	if c:IsLevelAbove(12) then
		return Duel.IsExistingMatchingCard(c101214306.thfilter,tp,LOCATION_DECK,0,1,nil) or
		Duel.IsExistingMatchingCard(c101214306.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
end
function c101214306.thfilter(c)
	return c:IsSetCard(0xef5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101214306.spfilter(c,e,tp)
	return c:IsSetCard(0xef5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c101214306.filter(c,e,tp)
	return c101214306.spfilter(c,e,tp) or c101214306.thfilter(c)
end
function c101214306.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101214306.costfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return c:IsAbleToRemoveAsCost() and g:GetClassCount(Card.GetCode,nil)>3 end
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,4,4)
	if sg:GetCount()==4 then 
		sg:AddCard(c)
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end
end
function c101214306.costfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xef5) and not c:IsCode(101214306)
end
function c101214306.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101214306.lvfilter(chkc) and chkc:IsLocation(LOCATION_MZONE)
		and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c101214306.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	local tc=Duel.SelectTarget(tp,c101214306.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101214306.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)		
	end
end
function c101214306.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsSetCard(0xef5)
end