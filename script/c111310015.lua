--PM(프로토콜 마스터).7 에너지브리더
c111310015.AccessMonsterAttribute=true
c111310015.ProtocolMasterNumber=7
function c111310015.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310015.afil1,c111310015.afil2)
	c:EnableReviveLimit()
	--덱특소
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,111310015)
	e1:SetCondition(c111310015.hspcon)
	e1:SetTarget(c111310015.hsptg)
	e1:SetOperation(c111310015.hspop)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c111310015.con)
	c:RegisterEffect(e2)
	--파괴
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111310015,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c111310015.descost)
	e3:SetTarget(c111310015.destg)
	e3:SetOperation(c111310015.desop)
	c:RegisterEffect(e3)
end
function c111310015.afil1(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c111310015.afil2(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0
end
function c111310015.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310015.hspfilter(c,e,tp,lv)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c111310015.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ad=e:GetHandler():GetAdmin()
	local lv=ad:GetLevel()
	if ad==nil then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c111310015.hspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c111310015.hspop(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	local lv=ad:GetLevel()
	if ad==nil then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c111310015.hspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c111310015.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c111310015.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c111310015.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310015.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c111310015.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c111310015.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c111310015.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end