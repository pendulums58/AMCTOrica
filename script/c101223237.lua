--네우로시스의 지배력
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--발동 시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
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
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.IsExistingMatchingCard(s.rvchk,tp,LOCATION_EXTRA,0,1,nil)
			and Duel.GetLocationCount()>0
			and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local tc=Duel.SelectMatchingCard(tp,s.rvchk,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
			Duel.ConfirmCards(tc,1-tp)
			local g=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
			if g:GetCount()>0 and Duel.SpecialSummonStep(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local tc=g:GetFirst()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(12)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
				Duel.SpecialSummonComplete()
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
	return not c:IsType(TYPE_ACCESS) and c:IsLocation(LOCATION_EXTRA)
end
function s.rvchk(c)
	return c:IsType(TYPE_ACCESS)
end
function s.ccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:IsExists(Card.IsType,1,nil,TYPE_ACCESS)
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
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				while tc do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					e1:SetValue(1000)
					tc:RegisterEffect(e1)
					tc=g:GetNext()
				end
			end
		end
		if c:GetCounter(COUNTER_ASCENDANCY)==2 and Duel.RemoveAdmin(tp,1,1,1,1,REASON_EFFECT)>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if c:GetCount(COUNTER_ASCENDANCY)==3 then
			local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
			if g1:GetCount()>0 then
				Duel.Destroy(g1,REASON_EFFECT)
			end
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end
end