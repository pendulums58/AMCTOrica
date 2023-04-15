--델류지 레인드롭
function c101223097.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--퍼미션
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c101223097.codisable)
	e1:SetTarget(c101223097.tgdisable)
	e1:SetOperation(c101223097.opdisable)	
	c:RegisterEffect(e1)
	--본인 릴리스
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101223097.lchk)
	e2:SetCost(cyan.selfrelcost)
	cyan.JustSearch(e2,LOCATION_GRAVE,Card.IsAttribute,ATTRIBUTE_WATER)
	c:RegisterEffect(e2)
end
function c101223097.codisable(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetLevel()<e:GetHandler():GetLevel())
end
function c101223097.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101223097.opdisable(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or c:GetLevel()<2 or not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	if Duel.NegateActivation(ev) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		if c:IsLevel(1) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c101223097.lchk(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()==1
end