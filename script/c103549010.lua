--마칭 파이어 바벨리아
function c103549010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),4,2)
	c:EnableReviveLimit()
	--backfire activating from deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103549010,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,103549010)
	e1:SetCost(c103549010.spcost)
	e1:SetTarget(c103549010.sptg)
	e1:SetOperation(c103549010.spop)
	c:RegisterEffect(e1)
	--destroy and add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103549010,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,103549910)
	e2:SetTarget(c103549010.sptg2)
	e2:SetOperation(c103549010.ctop)
	c:RegisterEffect(e2)
	--distroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103549010,2))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,103549810)
	e3:SetCost(c103549010.discost)
	e3:SetTarget(c103549010.distg)
	e3:SetOperation(c103549010.disop)
	c:RegisterEffect(e3)
end
c103549010.counter_add_list={0x1325}
function c103549010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c103549010.stfilter(c,tp)
	return c:IsCode(82705573) and c:GetActivateEffect()
end
function c103549010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103549010.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp) end
end
function c103549010.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c103549010.stfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(g,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c103549010.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c103549010.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103549010.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c103549010.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c103549010.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		e:GetHandler():AddCounter(0x1325,2)
	end
end
function c103549010.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1325,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1325,3,REASON_COST)
end
function c103549010.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c103549010.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103549010.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function c103549010.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c103549010.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end