--스토리텔러-흘러가는 이야기
function c103550008.initial_effect(c)
	--엑시즈 소환
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--공격력 뻥
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103550008,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cyan.ovcost(1))
	e1:SetTarget(c103550008.atktg)
	e1:SetOperation(c103550008.atkop)
	c:RegisterEffect(e1)
	--데미지 주었을 때 1드로
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103550008,1))
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c103550008.spcon)
	cyan.JustDraw(e2,1)
	c:RegisterEffect(e2)	
end
function c103550008.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103550008.filter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c103550008.filter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSetCard(0x64a)
end
function c103550008.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c103550008.filter,tp,LOCATION_GRAVE,0,nil)
		local ct=g:GetClassCount(Card.IsCode,nil)
		if ct>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(ct*500)
			c:RegisterEffect(e1)
		end
	end
end
function c103550008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and e:GetHandler():GetOverlayGroup():IsExists(c103550008.tchk,1)
end
function c103550008.tchk(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end