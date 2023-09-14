--엑소스피어의 지배력
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--발동 시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--특소시 카운터
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.ccon)
	e2:SetTarget(s.ctg)
	e2:SetOperation(s.cop)
	c:RegisterEffect(e2)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.IsExistingMatchingCard(s.rvchk,tp,LOCATION_EXTRA,0,1,nil,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local tc=Duel.SelectMatchingCard(tp,s.rvchk,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
			Duel.ConfirmCards(tc,1-tp)
			local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetDescription(aux.Stringid(id,2))
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.splimit)
			Duel.RegisterEffect(e1,tp)			
		end
	end
end
function s.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function s.rvchk(c,tp)
	return c:IsType(TYPE_SYNCHRO)
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function s.tgfilter(c,tc)
	local sc=tc:GetSetCard()
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c:IsSetCardList(sc)
end
function s.ccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
function s.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(COUNTER_ASCENDANCY,1)
		Duel.BreakEffect()
		if c:GetCounter(COUNTER_ASCENDANCY)==1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_DISEFFECT)
			e1:SetValue(s.effectfilter)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
		local g=eg:Filter(Card.IsType,nil,TYPE_SYNCHRO)
		if c:GetCounter(COUNTER_ASCENDANCY)==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local g1=Duel.SelectMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,g)
			if g1:GetCount()>0 then
				Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		if c:GetCounter(COUNTER_ASCENDANCY)==3 then
			local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(g2,1-tp)
			end
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end
end
function s.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsActiveType(TYPE_MONSTER)
end
function s.spfilter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:IsExists(Card.IsSetCardList,1,nil,c)
		and c:IsType(TYPE_TUNER)
end