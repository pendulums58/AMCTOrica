--SMTP 스나이퍼
c111310076.AccessMonsterAttribute=true
function c111310076.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310076.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--몬스터 파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c111310076.thtg)
	e1:SetOperation(c111310076.thop)
	c:RegisterEffect(e1)	
end
function c111310076.afil1(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c111310076.filter(c)
	return c:GetAttack()<atk
end
function c111310076.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ad=e:GetHandler():GetAdmin()
	if chk==0 then return ad and Duel.IsExistingMatchingCard(c111310076.filter,tp,0,LOCATION_MZONE,1,nil,ad:GetAttack()) end
	local g=Duel.GetMatchingGroup(c111310076.filter,tp,0,LOCATION_MZONE,nil,ad:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c111310076.thop(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAttack()
	local g=Duel.GetMatchingGroup(c111310076.filter,tp,0,LOCATION_MZONE,nil,ad:GetAttack())
	Duel.Destroy(g,REASON_EFFECT)
end