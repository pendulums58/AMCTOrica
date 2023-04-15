--C(크루세이더).컨티뉴엄-티아
function c101235005.initial_effect(c)
	c:SetSPSummonOnce(101235005)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c101235005.lcheck)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,101235005)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101235005.cost)
	e1:SetTarget(c101235005.target)
	e1:SetOperation(c101235005.activate)
	c:RegisterEffect(e1)
end
function c101235005.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x653)
end
function c101235005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c101235005.mfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101235005.filter(c,e,tp)
	return (c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (c:IsFaceup() and c:IsSSetable())
end
function c101235005.sfilter(c,e,tp)
	return c:IsFaceup() and c:IsSSetable()
end
function c101235005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101235005.filter(chkc,e,tp) end
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101235005.mfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)) or (Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101235005.sfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)) end
	if (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c101235005.mfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c101235005.sfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectTarget(tp,c101235005.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	elseif (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c101235005.mfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectTarget(tp,c101235005.mfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c101235005.sfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectTarget(tp,c101235005.sfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	end
end
function c101235005.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local typ=tc:GetType()
	if (typ & TYPE_MONSTER)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if (typ & TYPE_SPELL+TYPE_TRAP)>0 and tc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,tc)
	end
end