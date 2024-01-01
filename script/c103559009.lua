--구축하는 신비
local s,id=GetID()
function s.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,s.afil1,aux.TRUE)
	c:EnableReviveLimit()		
	--신비 공통 효과
	cyan.AddHaloEffect(c,TYPE_ACCESS)	
	--무효
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(s.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)	
	--공격력 0
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(0)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.disable)
	c:RegisterEffect(e2)
	--마법 퍼미션
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.condition1)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)	
end
function s.afil1(c)
	return c:IsSetCard(SETCARD_MYSTERY) and c:IsType(TYPE_ACCESS)
end
function s.disable(e,c)
	return c:GetColumnGroup():IsExists(s.dischk,1,nil,e:GetHandler():GetControler())
end
function s.dischk(c,tp)
	return c:IsControler(tp) and c:IsSetCard(SETCARD_MYSTERY) and c:IsType(TYPE_MONSTER)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetAdmin()== nil then return false end
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_SPELL) and rc~=c
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			local tc=e:GetHandler():GetAdmin()
			if tc and tc:GetAttack()>0 then
				Duel.BreakEffect()
				Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
			end
		end
	end
end