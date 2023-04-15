--드림 오브 크리스탈
function c101223184.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c101223184.unlockeff)	
	--개방 드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	cyan.JustDraw(e1,2)
	c:RegisterEffect(e1)
	--무효 파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c101223184.condition)
	e2:SetCost(cyan.selfrelcost)
	e2:SetTarget(c101223184.target)
	e2:SetOperation(c101223184.operation)
	c:RegisterEffect(e2)	
end
function c101223184.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(c101223184.damval)
	Duel.RegisterEffect(e4,tp)
end
function c101223184.damval(e,re,val,r,rp,rc)
	if rc and rc:GetSummonLocation()==LOCATION_EXTRA and r==REASON_BATTLE then
		val=val-1000
	end
	if val<0 then val=0 end
	return val
end
function c101223184.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetSummonLocation()==LOCATION_EXTRA and Duel.IsChainNegatable(ev)
		and Duel.GetTurnPlayer()==tp
end
function c101223184.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101223184.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
