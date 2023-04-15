--창성의 외침
function c101248011.initial_effect(c)
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101248011,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetTarget(c101248011.target)
	e1:SetOperation(c101248011.activate)
	c:RegisterEffect(e1)
	--덱 특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101248011,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c101248011.cost1)
	e2:SetTarget(c101248011.target1)
	e2:SetOperation(c101248011.activate1)
	c:RegisterEffect(e2)	
end
function c101248011.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101248011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101248011.filter(chkc) and chkc~=e:GetHandler() end
	local ct=0
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0xfe) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x620) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x622) then ct=ct+1 end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c101248011.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101248011.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101248011.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end

function c101248011.cfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c101248011.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101248011.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c101248011.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c101248011.filter1(c,e,tp)
	return c:IsSetCard(0x622) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101248011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c101248011.filter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101248011.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101248011.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end