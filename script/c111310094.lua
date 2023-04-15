--OSPF 다이버
c111310094.AccessMonsterAttribute=true
function c111310094.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310094.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--파괴
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(111310094,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCost(c111310094.descost)
	e4:SetTarget(c111310094.destg)
	e4:SetOperation(c111310094.desop)
	c:RegisterEffect(e4)
end
function c111310094.afil1(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c111310094.costfilter(c,ad)
	return c:GetAttack()>ad:GetAttack() and c:IsAbleToGraveAsCost()
end
function c111310094.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ad=e:GetHandler():GetAdmin()
	if chk==0 then return ad and Duel.IsExistingMatchingCard(c111310094.costfilter,tp,LOCATION_HAND,0,1,nil,ad) end
	local g=Duel.SelectMatchingCard(tp,c111310094.costfilter,tp,LOCATION_HAND,0,1,1,nil,ad)
	Duel.SendtoGrave(g,REASON_COST)
end
function c111310094.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c111310094.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end