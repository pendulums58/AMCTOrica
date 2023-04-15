--대검의 잔불여우
function c111330006.initial_effect(c)
	--링크 소환
	Link.AddProcedure(c,nil,2,4,c111330006.lcheck)	
	c:EnableReviveLimit()	
	--파괴 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--공격력 배
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c111330006.thcon)
	e3:SetTarget(c111330006.atktg)
	e3:SetOperation(c111330006.atkop)
	c:RegisterEffect(e3)	
	--데미지
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdcon)
	e4:SetTarget(c111330006.damtg)
	e4:SetOperation(c111330006.damop)
	c:RegisterEffect(e4)
end
function c111330006.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x638,lc,sumtype,tp)
end
function c111330006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c111330006.deschk,1,nil,tp)
end
function c111330006.descchk(c,tp)
	return c:IsPreviousControler(tp) and c:GetPreviousLocation(LOCATION_MZONE)
end
function c111330006.descchk1(c,tp)
	return c:IsPreviousControler(tp) and c:GetPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_TOKEN)
end
function c111330006.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if eg:IsExists(c111330006.deschk1,1,nil,tp) then
		Duel.SetChainLimit(c111330006.chlimit)
	end
end
function c111330006.chlimit(e,ep,tp)
	return tp==ep
end
function c111330006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END,1)
		c:RegisterEffect(e1)
	end
end
function c111330006.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c111330006.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end