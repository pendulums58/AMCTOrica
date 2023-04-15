--HTTP 레인저
c111310073.AccessMonsterAttribute=true
function c111310073.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310073.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310073,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310073.descon)
	e1:SetTarget(c111310073.destg)
	e1:SetOperation(c111310073.desop)
	e1:SetCountLimit(1,111310073)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c111310073.descon1)
	c:RegisterEffect(e2)
end
function c111310073.afil1(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c111310073.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310073.descon1(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAttack()
	return ad and eg:IsExists(Card.IsAttackAbove,1,nil,ad:GetAttack())
end
function c111310073.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c111310073.desfilter(chkc,c:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c111310073.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c111310073.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c111310073.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c111310073.desfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end