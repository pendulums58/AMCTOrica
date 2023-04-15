--DNS 블래스터
c111310060.AccessMonsterAttribute=true
function c111310060.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310060.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--무효
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310060,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c111310060.condition1)
	e1:SetTarget(c111310060.target)
	e1:SetOperation(c111310060.operation)
	c:RegisterEffect(e1)	
end
function c111310060.afil1(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c111310060.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetAdmin()== nil then return false end
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and rc:GetAttack()<c:GetAdmin():GetAttack()
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c111310060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c111310060.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			local tc=eg:GetFirst()
			if tc and tc:GetAttack()>0 then
				Duel.BreakEffect()
				Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
			end
		end
	end
end