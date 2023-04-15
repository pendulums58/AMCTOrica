--핑 제너레이터
c111310007.AccessMonsterAttribute=true
function c111310007.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310007.afil1,c111310007.afil2)
	c:EnableReviveLimit()
	--번 데미지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c111310007.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c111310007.damcon)
	e2:SetOperation(c111310007.damop)
	c:RegisterEffect(e2)
	--효과 내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c111310007.spcon)
	e3:SetTarget(c111310007.attg)
	e3:SetOperation(c111310007.atop)
	c:RegisterEffect(e3)	
end
function c111310007.afil1(c)
	return c:IsType(TYPE_EFFECT)
end
function c111310007.afil2(c)
	return c:IsType(TYPE_LINK)
end
function c111310007.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(111310007,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c111310007.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	local lv=ad:GetLevel()
	if ad:IsType(TYPE_LINK) then lv=ad:GetLink() end
	return lv>0 and ep~=tp and c:GetFlagEffect(111310007)~=0
end
function c111310007.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	local lv=ad:GetLevel()
	if ad:IsType(TYPE_LINK) then lv=ad:GetLink() end
	Duel.Hint(HINT_CARD,0,111310007)
	Duel.Damage(1-tp,lv*100,REASON_EFFECT)
end
function c111310007.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and (c:IsReason(REASON_BATTLE) or (rp~=tp and c:GetPreviousControler()==tp))
end
function c111310007.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c111310007.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c111310007.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c111310007.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end