--인과의 워울프소녀
function c111331099.initial_effect(c)
	--완전 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c111331099.imcon)
	e1:SetValue(c111331099.efilter)
	c:RegisterEffect(e1)
	--패 발동
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCountLimit(1,111331099)
	e2:SetCost(cyan.selftgcost)
	e2:SetCondition(c111331099.spcon)
	e2:SetTarget(c111331099.sptg)
	e2:SetOperation(c111331099.spop)
	c:RegisterEffect(e2)
end
function c111331099.imcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c111331099.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c111331099.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsOwner,1,nil,tp)
end
function c111331099.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c111331099.spfilter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c111331099.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local g1=Group.CreateGroup()
	g:Merge(eg)
	g1:Merge(eg)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		g=g:Filter(Card.IsPreviousControler,nil,1-tp)
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<1 then
		g1=g1:Filter(Card.IsPreviousControler,nil,tp)
	end
	g:Merge(g1)
	local g=g:FilterSelect(tp,c111331099.spfilter,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc:GetPreviousControler()==1-tp then
			if Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
				local g2=Duel.SelectMatchingCard(tp,c111331099.thfilter,tp,LOCATION_DECK,0,1,1,nil)
				if g2:GetCount()>0 then
					Duel.SendtoHand(g2,nil,REASON_EFFECT)
				end
			end
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		
		end
	end
end
function c111331099.spfilter(c,e,tp)
	local sel=0
	if c:IsPreviousControler(tp) then sel=tp end
	if c:IsPreviousControler(1-tp) then opp=1-tp end
	return c:IsOwner(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(sel,LOCATION_MZONE)>0 and not c:IsLocation(LOCATION_DECK)
end
function c111331099.thfilter(c)
	return c:IsAbleToHand() and (c:IsCode(FV) or c:IsCode(PI) or c:IsSetCard(0x639))
end
