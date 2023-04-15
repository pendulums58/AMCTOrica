--DHCP 버스터
c111310039.AccessMonsterAttribute=true
function c111310039.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310039.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--광역 파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROYE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c111310039.destg)
	e1:SetOperation(c111310039.desop)
	c:RegisterEffect(e1)
end
function c111310039.afil1(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c111310039.filter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function c111310039.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if chk==0 then return ad and Duel.IsExistingMatchingCard(c111310039.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c111310039.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,ad:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c111310039.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or ad then return end
	local g=Duel.GetMatchingGroup(c111310039.filter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e),ad:GetAttack())
	local ct=Duel.Destroy(g,REASON_EFFECT)
end
