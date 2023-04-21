--에르스탈의 지배력
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--발동 시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.IsExistingMatchingCard(s.rvchk,tp,LOCATION_EXTRA,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local tc=Duel.SelectMatchingCard(tp,s.rvchk,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			Duel.ConfirmCards(tc,1-tp)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
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
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function s.rvchk(c,e,tp)
	return c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c,e,tp)
end
function s.spfilter(c,tc,e,tp)
	local lv=tc:GetRank()
	return c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.ccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:IsExists(Card.IsType,1,nil,TYPE_XYZ)
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
			if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_MZONE,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				local g=Duel.GetOverlayGroup(tp,1,0):Filter(Card.IsAbleToHand,nil)
				g=g:Select(tp,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(g,1-tp)
				end
			end
		end
		if c:GetCounter(COUNTER_ASCENDANCY)==2 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if g1:GetCount()>0 then
				Duel.Destroy(g1,REASON_EFFECT)
			end
		end
		if c:GetCounter(COUNTER_ASCENDANCY)==3 then
			local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,0,0,2,nil)
			g2:AddCard(c)
			local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
			if tc:GetCount()>0 then 
				tc=tc:GetFirst()
				Duel.Overlay(tc,g2)
			else
				Duel.SendtoGrave(c,REASON_EFFECT)
			end
		end
	end
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsAbleToHand,1,nil)
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end