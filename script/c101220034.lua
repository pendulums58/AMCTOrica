--불면의 직시자 레티시아
function c101220034.initial_effect(c)
	--엑시즈 조건
	aux.AddXyzProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FIEND),4,3)
	c:EnableReviveLimit()	
	--소재로 넣는다
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101220034,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101220034.matcon)
	e1:SetTarget(c101220034.mattg)
	e1:SetOperation(c101220034.matop)
	c:RegisterEffect(e1)
	--무효
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c101220034.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--무효 혹은 제외
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62476197,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c101220034.cost)
	e3:SetCondition(c101220034.rmcon)
	e3:SetOperation(c101220034.rmop)
	c:RegisterEffect(e3)
end
function c101220034.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c101220034.matfilter(c)
	return c:IsSetCard(0xefa) and c:IsType(TYPE_XYZ) and c:IsCanOverlay()
end
function c101220034.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101220034.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c101220034.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
 	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c101220034.matfilter,tp,LOCATION_GRAVE,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c101220034.disable(e,c)
	local ct=e:GetHandler():GetOverlayCount()
	if ct==0 then return false end
	if not (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) then return false end
	if c:IsType(TYPE_LINK) then return c:GetLink()<ct end
	if c:IsType(TYPE_XYZ) then return c:GetRank()<ct end
	return c:GetLevel()<ct
end
function c101220034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101220034.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) 
end
function c101220034.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) and Duel.IsChainNegatable(ev)
		and Duel.SelectYesNo(1-tp,aux.Stringid(80764541,0)) then
		Duel.NegateEffect(ev)
		Duel.NegateEffect(0)
		return
	end
	local tc=re:GetHandler()
	if tc:IsRelateToEffect(e) then
		local g1=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,nil,tc:GetCode())
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
end
