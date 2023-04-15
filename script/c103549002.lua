--마칭 파이어 아포칼레아
function c103549002.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103549002,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,103549002)
	e1:SetCondition(c103549002.spcon)
	e1:SetOperation(c103549002.spop)
	c:RegisterEffect(e1)
	--deck spsm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103549002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,103549902)
	e2:SetCondition(c103549002.spcon2)
	e2:SetTarget(c103549002.sptg2)
	e2:SetOperation(c103549002.spop2)
	c:RegisterEffect(e2)
end
c103549002.counter_add_list={0x1325}
function c103549002.spcfilter(c,tp)
	return c:IsCanRemoveCounter(tp,0x1325,1,REASON_COST)
end
function c103549002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c103549002.spcfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local ct=0
	for tc in aux.Next(g) do
		ct=ct+tc:GetCounter(0x1325)
	end
	return ct>=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c103549002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c103549002.spcfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if #g==1 then
		g:GetFirst():RemoveCounter(tp,0x1325,1,REASON_COST)
	else
		for i=1,1 do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(103549002,2))
		local tg=Duel.SelectMatchingCard(tp,c103549002.spcfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		tg:GetFirst():RemoveCounter(tp,0x1325,1,REASON_COST)
		end
	end
end
function c103549002.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c103549002.spfilter(c,e,tp)
	return (c:IsSetCard(0xac6) and c:IsType(TYPE_MONSTER) and not c:IsCode(103549002))
end
function c103549002.spfilter2(c)
	return (c:IsSetCard(0xac6) and c:IsType(TYPE_MONSTER) and not c:IsCode(103549002))
end
function c103549002.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c103549002.spfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c103549002.spfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c103549002.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c103549002.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c103549002.spfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end