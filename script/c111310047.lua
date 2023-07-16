--클라우드 페인터
c111310047.AccessMonsterAttribute=true
function c111310047.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE,c111310047.accheck)
	c:EnableReviveLimit()
	--액세스 소환시 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310047,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c111310047.spcon)
	e1:SetTarget(c111310047.sptg)
	e1:SetOperation(c111310047.spop)
	c:RegisterEffect(e1)
	--파괴내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c111310047.filter2)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
end
function c111310047.accheck(c,tc,ac)
	local lv=tc:GetLevel()
	if c:GetLevel()<=0 or lv<=0 then return false end
	if c:GetLevel()+lv==8 then return true end
	return false
end
function c111310047.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310047.filter(c,e,tp,lv)
	if c:GetLevel()<=0 then return false end
	local splv=c:GetLevel()+lv
	return Duel.IsExistingMatchingCard(c111310047.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,splv)
end
function c111310047.spfilter(c,e,tp,lv)
	return c:GetLevel()==lv
end
function c111310047.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ad=e:GetHandler():GetAdmin()
	if not ad then return false end
	if ad:GetLevel()<=0 then return false end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c111310047.filter(chkc,e,tp,ad:GetLevel()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c111310047.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ad:GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c111310047.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ad:GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c111310047.spop(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	local tc=Duel.GetFirstTarget()
	if not ad then return end
	if ad:GetLevel()<=0 then return end
	if tc:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		if tc:GetLevel()<=0 then return end
		local splv=ad:GetLevel()+lv
		if Duel.IsExistingMatchingCard(c111310047.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,splv) then
			local g=Duel.SelectMatchingCard(tp,c111310047.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,splv)
			if g:GetCount()>0 then
				local tc1=g:GetFirst()
				Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetTargetRange(1,0)
				e2:SetReset(RESET_PHASE+PHASE_END)
				e2:SetTarget(c111310047.splimit)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function c111310047.splimit(e,c)
	return not c:IsType(TYPE_ACCESS) and c:IsLocation(LOCATION_EXTRA)
end
function c111310047.filter2(e,c)
	return c:IsType(TYPE_ACCESS)
end