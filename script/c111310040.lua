--NAT 슈터
c111310040.AccessMonsterAttribute=true
function c111310040.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310040.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c111310040.thtg)
	e1:SetOperation(c111310040.thop)
	c:RegisterEffect(e1)
end
function c111310040.afil1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c111310040.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad==nil then return false end
	if chkc then return chkc:IsOnField() and c111310040.desfilter(chkc,ad:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c111310040.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,ad:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c111310040.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,ad:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c111310040.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c111310040.desfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end