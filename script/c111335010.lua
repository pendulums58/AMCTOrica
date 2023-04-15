--희망이 흐르는 강
function c111335010.initial_effect(c)
--서치
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111335010+EFFECT_COUNT_CODE_OATH)	
	e1:SetTarget(c111335010.target)
	e1:SetOperation(c111335010.activate)
	c:RegisterEffect(e1)	
--토큰 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111335010,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,111335509)
	e2:SetCost(c111335010.tkcost)	
	e2:SetTarget(c111335010.tktg)
	e2:SetOperation(c111335010.tkop)
	c:RegisterEffect(e2)
--바르그 소환	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111335010,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_FZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)	
	e3:SetCountLimit(1,111335709)
	e3:SetCost(c111335010.spcost)
	e3:SetTarget(c111335010.sptg)
	e3:SetOperation(c111335010.spop)
	c:RegisterEffect(e3)
end
c111335010.remove_counter=0x326  
--서치
function c111335010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsCanRemoveCounter(tp,1,0,0x326,1,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(111335010,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		Duel.RemoveCounter(tp,1,0,0x326,1,REASON_COST)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end	
function c111335010.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x652) and c:IsAbleToHand()
end
function c111335010.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c111335010.thfilter,tp,LOCATION_DECK,0,nil)
	if e:GetHandler():IsRelateToEffect(e) and e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		end	
end
--토큰 소환
function c111335010.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x326,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x326,1,REASON_COST)
end
function c111335010.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,111332103,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c111335010.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,111332103,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,111332103)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c111335010.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c111335010.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x652) and c:IsLocation(LOCATION_EXTRA)
end
--바르그 소환
function c111335010.lilfilter(c,e,tp)
	return c:IsType(TYPE_TOKEN)
end
function c111335010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111335010.lilfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,nil) end
	local g=Duel.GetReleaseGroup(tp):Filter(c111335010.lilfilter,nil,e,tp)
	local g1=Duel.GetMatchingGroup(c111335010.lilfilter,tp,0,LOCATION_MZONE,nil,e,tp)
	g:Merge(g1)
	local tc=g:Select(tp,1,1,nil)
	Duel.Release(tc,REASON_COST)	
end
function c111335010.spfilter(c,e,tp)
	return c:IsSetCard(0x652) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_WARRIOR)
end
function c111335010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c111335010.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c111335010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c111335010.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end