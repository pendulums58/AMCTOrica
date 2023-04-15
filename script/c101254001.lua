--타리네코 #이스트 스타일
function c101254001.initial_effect(c)
	--특소시 효과 발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(cyan.dhcost(1))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,101254001)
	e1:SetTarget(c101254001.optg)
	e1:SetOperation(c101254001.opop)
	c:RegisterEffect(e1)
	--묘지로 보내졌을 때 내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c101254001.decop)
	c:RegisterEffect(e3)	
end
function c101254001.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local op0=0
	local op1=0
	if Duel.IsExistingMatchingCard(c101254001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then op0=1 end
	if Duel.IsExistingMatchingCard(c101254001.thfilter,tp,LOCATION_REMOVED,0,2,nil)
		then op1=1 end
	if chk==0 then return op0==1 or op1==1 end
	local sel=0
	if op0==0 then sel=1 end
	if op0==1 and op1==1 then sel=Duel.SelectOption(tp,aux.Stringid(101254001,0),aux.Stringid(101254001,1)) end
	if sel==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	end
	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_REMOVED)
	end
	e:SetLabel(sel)
end
function c101254001.spfilter(c,e,tp)
	return c:IsSetCard(0x626) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101254001.thfilter(c)
	return c:IsSetCard(0x626) and c:IsAbleToHand()
end
function c101254001.opop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101254001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if sel==1 then
		if not Duel.IsExistingMatchingCard(c101254001.thfilter,tp,LOCATION_REMOVED,0,2,nil) then return end
		local g=Duel.SelectMatchingCard(tp,c101254001.thfilter,tp,LOCATION_REMOVED,0,2,2,nil)
		if g:GetCount()==2 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function c101254001.decop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTarget(c101254001.target)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101254001.target(e,c)
	return c:IsSetCard(0x626)
end
