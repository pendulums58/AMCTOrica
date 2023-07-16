--팔레트 트래블러
function c111310031.initial_effect(c)
	--링크 소환
	aux.AddLinkProcedure(c,nil,2,2,c111310031.lcheck)
	c:EnableReviveLimit()
	--공격력
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(CYAN_EFFECT_ACCESS_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c111310031.indtg)
	e1:SetValue(c111310031.slevel)
	c:RegisterEffect(e1)
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310031,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,111310031)
	e2:SetTarget(c111310031.sptg)
	e2:SetOperation(c111310031.spop)
	c:RegisterEffect(e2)
end
function c111310031.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_ACCESS)
end
function c111310031.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c111310031.slevel(e,c,acc)
	return c:GetAttack()+1000
end
function c111310031.costfilter(c,e,tp)
	return c:IsType(TYPE_ACCESS) and c:IsAbleToRemoveAsCost() and c:GetLevel()>0
		and Duel.IsExistingTarget(c111310031.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetLevel())
end
function c111310031.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_ACCESS) and c:GetLevel()<lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c111310031.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone(tp) 
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c111310031.spfilter(chkc,e,tp,e:GetLabel()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and zone~=0 and Duel.IsExistingMatchingCard(c111310031.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c111310031.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local lv=g:GetFirst():GetLevel()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c111310031.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c111310031.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end