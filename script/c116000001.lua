--라디언트의 괴도 이오시프
local s,id=GetID()
function c116000001.initial_effect(c)
	cyan.AddAccessProcedure(c,s.afilter,aux.TRUE)
	c:EnableReviveLimit()
	--내 효과마다 강제 체인 후 공수 500상승
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--퍼미션 후 복사
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,116000001)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	aux.GlobalCheck(s,function()
		s.type_list={}
		s.type_list[0]=0
		s.type_list[1]=0
		aux.AddValuesReset(function()
				s.type_list[0]=0
				s.type_list[1]=0
			end)
		end)
end
function s.afilter(c)
	return c:IsSetCard(0x60a) or c:IsSetCard(0xef4)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and s.type_list[tp]&re:GetActiveType()==0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	s.type_list[tp]=s.type_list[tp]|(re:GetActiveType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP))
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e2)
	end
end
s.listed_series={0xefb}
s.listed_names={id}
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		local token=Duel.CreateToken(tp,re:GetHandler():GetCode())
		Duel.SendtoHand(token,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,token)
	end
end