--환영검 구울라틴
function c101255009.initial_effect(c)
	--특정 상황에서 소멸
	cyan.SemiTokenAttribute(c)	
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c101255009.target)
	e1:SetOperation(c101255009.operation)
	c:RegisterEffect(e1)
	--장착 제한
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c101255009.eqlimit)
	c:RegisterEffect(e2)
	--비대상 내성(장착 몬스터)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(c101255009.efilter1)
	c:RegisterEffect(e3)	
	--비대상 내성(구울라틴 본인)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetValue(c101255009.efilter)
	c:RegisterEffect(e4)
	--공격력을 0으로
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c101255009.atkcon)
	e5:SetOperation(c101255009.atkop)
	c:RegisterEffect(e5)
end
function c101255009.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c101255009.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c101255009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101255009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101255009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c101255009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c101255009.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c101255009.efilter(e,re)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if re:GetHandler():GetControler()==e:GetHandler():GetControler() then return false end
	if not g then return true end
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and e:GetOwner()~=re:GetOwner() and not g:IsContains(e:GetHandler())
end
function c101255009.efilter1(e,re)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local eq=e:GetHandler():GetEquipTarget()
	if not g then return true end
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and e:GetOwner()~=re:GetOwner() and not g:IsContains(eq)
end
	
function c101255009.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec~=Duel.GetAttacker() and ec~=Duel.GetAttackTarget() then return false end
	local tc=ec:GetBattleTarget()
	return tc and tc:IsFaceup()
end
function c101255009.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ec=c:GetEquipTarget()
	local tc=ec:GetBattleTarget()
	if ec and tc and ec:IsFaceup() and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
	end
end
