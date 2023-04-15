--UI 퍼블리셔
c101241015.AccessMonsterAttribute=true
function c101241015.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241015.afil1,c101241015.afil2)
	c:EnableReviveLimit()
	--레벨 변경
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(c101241015.lvcon)
	e1:SetTarget(c101241015.lvtg)
	e1:SetOperation(c101241015.lvop)
	c:RegisterEffect(e1)
	--파괴시 드로우
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c101241015.bcon)
	e2:SetTarget(c101241015.target)
	e2:SetOperation(c101241015.activate)
	c:RegisterEffect(e2)
end
function c101241015.afil1(c)
	return c:IsLevelBelow(3) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)
end
function c101241015.afil2(c)
	return c:IsLevelBelow(6)
end
function c101241015.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAdmin():GetLevel()>0
end
function c101241015.filter(c)
	return c:GetLevel()>0 and (c:IsSummonType(SUMMON_TYPE_SPECIAL) or c:IsSummonType(SUMMON_TYPE_NORMAL)) and c:IsType(TYPE_MONSTER)
end
function c101241015.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101241015.filter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c101241015.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101241015.filter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	local lv=e:GetHandler():GetAdmin():GetLevel()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c101241015.bcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if not a==e:GetHandler() then return false end
	if d:IsControler(tp) then a,d=d,a end
	return d:GetLevel()==a:GetAdmin():GetLevel()
end
function c101241015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101241015.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end