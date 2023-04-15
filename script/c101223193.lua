--알케미라이즈 레조넌스
local s,id=GetID()
function s.initial_effect(c)
	--슈퍼 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s.thmchk(tp,e:GetHandler()) or s.thtchk(tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.dischk,tp,LOCATION_HAND,0,1,nil) then
		local g=Duel.SelectMatchingCard(tp,s.dischk,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			local thty=TYPE_SPELL
			if g:GetFirst():IsType(TYPE_SPELL) then thty=TYPE_TRAP end
			if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
				local g1=Duel.SelectMatchingCard(tp,s.thfilter3,tp,LOCATION_DECK,0,1,1,nil,thty)
				if g1:GetCount()>0 then
					Duel.SendtoHand(g1,nil,REASON_EFFECT)
					Duel.ConfirmCards(g1,1-tp)
					if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetCode(EFFECT_CANNOT_SSET)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetTargetRange(1,0)
					Duel.RegisterEffect(e1,tp)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e2:SetCode(EFFECT_CANNOT_ACTIVATE)
					e2:SetTargetRange(1,0)
					e2:SetValue(s.aclimit)
					e2:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e2,tp)
				end
			end
		end
	end
end
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.dischk(c)
	local tp=c:GetControler()
	local thty=TYPE_SPELL
	if c:IsType(TYPE_SPELL) then thty=TYPE_TRAP end
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(s.thfilter3,tp,LOCATION_DECK,0,1,nil,thty)
end
function s.thfilter3(c,ty)
	return c:IsType(ty) and c:IsAbleToHand()
end
function s.thmchk(tp,c)
	return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.disfilter1,tp,LOCATION_HAND,0,1,c)
end
function s.thfilter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function s.disfilter1(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_TRAP)
end
function s.thtchk(tp,c)
	return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.disfilter2,tp,LOCATION_HAND,0,1,c)
end
function s.thfilter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_TRAP)
end
function s.disfilter2(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SPELL)
end