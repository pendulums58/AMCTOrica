--자가호령
function c101223085.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101223085+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101223085.tg)
	e1:SetOperation(c101223085.op)
	c:RegisterEffect(e1)
end
function c101223085.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101223085.dfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101223085.dfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c101223085.dfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,nil,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101223085.dfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(c101223085.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
		and Duel.GetMZoneCount(tp,c)>0
end
function c101223085.spfilter(c,e,tp,tc)
	return c:IsSetCardList(tc) and c:IsAttack(tc:GetAttack()) and c:IsDefense(tc:GetDefense())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(tc:GetCode())
end
function c101223085.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if not c101223085.dfilter(tc,e,tp) then return end
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,c101223085.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end