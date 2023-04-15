--액세스 코드『신살마녀』
function c101253002.initial_effect(c)
	--패에서 특소
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101253002)
	e1:SetCondition(c101253002.spcon)
	e1:SetOperation(c101253002.spop)
	c:RegisterEffect(e1)
	--효과 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ADMIN)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(c101253002.condition)
	e2:SetValue(c101253002.efilter)
	c:RegisterEffect(e2)
	--소재로 사용시
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101253002,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c101253002.spcon1)
	e3:SetOperation(c101253002.damop)
	c:RegisterEffect(e3)		
end
function c101253002.spfilter(c,ft,tp)
	return c:IsSetCard(0x612)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c101253002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c101253002.spfilter,1,nil,ft,tp)
end
function c101253002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c101253002.spfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c101253002.condition(e)
	return e:GetHandler():IsSetCard(0x612)
end
function c101253002.efilter(e,te)
	local c=e:GetOwner()
	local tc=te:GetOwner()
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner() and c:GetAttack()<tc:GetAttack()
end
function c101253002.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_ACCESS
end
function c101253002.chainlm(e,rp,tp)
	return tp==rp
end
function c101253002.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
