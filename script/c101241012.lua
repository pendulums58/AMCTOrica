--기억의 변화
function c101241012.initial_effect(c)
	--특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101241012)
	e1:SetTarget(c101241012.sptg)
	e1:SetOperation(c101241012.spop)
	c:RegisterEffect(e1)
end
function c101241012.filter1(c,e,tp)
	local rc=Duel.ReadCard(c,CARDDATA_SETCODE)
	return rc>0 and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c101241012.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,rc,c)
end
function c101241012.filter2(c,e,tp,rc,ckc)
	local fc=Duel.ReadCard(c,CARDDATA_SETCODE)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsSetCardList(rc)
		and c:IsAttack(ckc:GetAttack()) and c:IsDefense(ckc:GetDefense()) and c:IsLevel(ckc:GetLevel()) and fc>0
end
function c101241012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101241012.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.SelectTarget(tp,c101241012.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101241012.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local rc=Duel.ReadCard(tc,CARDDATA_SETCODE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101241012.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,rc,tc)
	if g:GetCount()>0 then
		local gf=g:GetFirst()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local fc=Duel.ReadCard(gf,CARDDATA_SETCODE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetLabel(rc,fc)
		e1:SetTarget(c101241012.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101241012.splimit(e,c)
	return not c:IsSetCardMergeList(e:GetLabel())
end