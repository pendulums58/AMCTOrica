--수렵자 개
local s,id=GetID()
function s.initial_effect(c)
	--데미지를 밸로키랍토르
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetCondition(s.damcon)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e1)
	--공격력 상승
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--공업
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,{id,1})
	e4:SetCondition(s.bufcon)
	e4:SetTarget(s.buftg)
	e4:SetOperation(s.bufop)
	c:RegisterEffect(e4)
end
function s.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttackAbove,tp,0,LOCATION_MZONE,1,nil,1) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if #g>0 then
			local tg=g:GetMaxGroup(Card.GetAttack)
			local atk=tg:GetFirst():GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			c:RegisterEffect(e1,true)
		end
	end
end
function s.bufcon(e,tp,eg,ep,ev,re,r,rp)
	return YiPi.IsHuntingTargetExists(tp,0,1) and YiPi.SpellHunterCheck(e:GetHandler())
end
function s.buftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return YiPi.IsAbleToTag(c,e,tp) end
	Duel.SetOperation(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_SZONE)
end
function s.bufop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingcard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)	
		YiPi.Tag(c,e,tp)
	end
end