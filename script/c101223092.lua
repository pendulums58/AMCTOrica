--프라임 코드 인핸스
function c101223092.initial_effect(c)
	aux.AddCodeList(c,101223003)
	--프라임 코드 액세스
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cyan.dhcost(1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101223092.target)
	e1:SetOperation(c101223092.operation)
	c:RegisterEffect(e1)
	--슈퍼 덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVEV)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101223092.tgtg)
	e2:SetOperation(c101223092.tgop)
	c:RegisterEffect(e2)
end
function c101223092.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REMOVED,0,3,nil,chkc:GetCode())
		and Duel.IsExistingMatchingCard(c101223092.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,chkc)
		and chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c101223092.tgfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local tc=Duel.SelectTarget(tp,c101223092.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101223092.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	local g=Duel.SelectMatchingCard(tp,c101223092.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
	if g:GetCount()>0 then
		local g1=g:GetFirst()
		Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP)
		g1:RegisterFlagEffect(101223092,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c101223092.descon)
		e1:SetOperation(c101223092.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(g1)
		Duel.RegisterEffect(e1,tp)
		g1:CompleteProcedure()
	end
end
function c101223092.tgfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REMOVED,0,3,nil,c:GetCode())
		and Duel.IsExistingMatchingCard(c101223092.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
		and c:IsType(TYPE_MONSTER)
end
function c101223092.spfilter(c,e,tp,tc)
	return c.primecode_name==tc:GetCode() and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c101223092.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(101223092)~=0
end
function c101223092.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Exile(tc,REASON_EFFECT)
end
function c101223092.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101223092.relfilter,1,nil,tp) end
	local tc=Duel.SelectReleaseGroup(tp,c101223092.relfilter,1,1,nil,tp):GetFirst()
	if tc then
		e:SetLabel(tc:GetCode())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101223092.relfilter(c,tp)
	return Duel.IsExistingMatchingCard(c101223092.tgfilter1,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c101223092.tgfilter1(c,code)
	return c:IsCode(code) and c:IsAbleToGrave()
end
function c101223092.tgop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local g=Duel.GetMatchingGroup(c101223092.tgfilter1,tp,LOCATION_DECK,0,nil,code)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end