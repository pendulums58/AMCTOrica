--디스턴스 메이커
function c101223077.initial_effect(c)
	--패발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,101223077)
	e1:SetCondition(c101223077.condition)
	e1:SetTarget(c101223077.target)
	e1:SetOperation(c101223077.activate)
	c:RegisterEffect(e1)
	--회복
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c101223077.rctg)
	e2:SetOperation(c101223077.rcop)
	c:RegisterEffect(e2)
end
function c101223077.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c101223077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
end
function c101223077.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetAttacker()
	if tg:IsAttackable() and not tg:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c101223077.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1200,tp,nil)
	if rp==1-tp then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,800,tp,nil)
	end
end
function c101223077.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1200,REASON_EFFECT)
	if rp==1-tp then
		Duel.Recover(tp,800,REASON_EFFECT)
	end	
end