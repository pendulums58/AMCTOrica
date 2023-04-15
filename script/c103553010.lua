--엘레멘트리
function c103553010.initial_effect(c)
	aux.AddCodeList(c,103553000)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,103553010)
	e1:SetCondition(cyan.IsUnlockState)
	e1:SetTarget(c103553010.sptg)
	e1:SetOperation(c103553010.spop)
	c:RegisterEffect(e1)
	--세로열 말살
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c103553010.tdcost)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c103553010.destg)
	e2:SetOperation(c103553010.desop)
	c:RegisterEffect(e2)
end
function c103553010.spfilter(c,e,tp)
	return c:IsCode(103553000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c103553010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c103553010.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c103553010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c103553010.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,g)==0 then
			cyan.AddFuriosoStack(tp,1)
		end
	end
end
function c103553010.tdfilter(c)
	return aux.IsCodeListed(c,103553000) and c:IsAbleToDeckAsCost() and not c:IsCode(103553010)
end
function c103553010.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c103553010.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>=1 and e:GetHandler():IsAbleToDeckAsCost() end
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,1)
	sg1:AddCard(e:GetHandler())
	Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c103553010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c103553010.dtfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c103553010.dtfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,c103553010.dtfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if tc then tc=tc:GetFirst() end
	local g=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c103553010.dtfilter(c,tp)
	return c:GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)>0
end
function c103553010.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if Duel.Destroy(g,REASON_EFFECT)<2 then
			cyan.AddFuriosoStack(tp,1)
		end
	end
end