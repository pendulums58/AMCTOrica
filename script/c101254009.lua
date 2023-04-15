--키리후다 #이스트 스타일
function c101254009.initial_effect(c)
	--링크 소환
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101254009.matfilter,1,1)
	--파괴 내성 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(c101254009.valcon)
	e1:SetCountLimit(1)
	e1:SetTarget(c101254009.tgtg)
	c:RegisterEffect(e1)
	--데미지 + 회복
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101254009,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101254009.damcon)
	e2:SetOperation(c101254009.damop)
	c:RegisterEffect(e2)
	--소재 떨어지면
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c101254009.spcon)
	e3:SetOperation(c101254009.spop)
	c:RegisterEffect(e3)
end
function c101254009.matfilter(c)
	return c:GetLevel()==4 and c:IsSetCard(0x626)
end
function c101254009.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c101254009.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c101254009.damfilter(c,tp)
	return c:IsControler(1-tp)
end
function c101254009.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101254009.damfilter,1,nil,tp)
end
function c101254009.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101254009)
	Duel.Damage(1-tp,400,REASON_EFFECT)
	Duel.Recover(tp,400,REASON_EFFECT)
end
function c101254009.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c101254009.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTarget(c101254009.rmtarget)
	e1:SetTargetRange(0xff, 0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101254009.rmtarget(e,c)
	local tp=e:GetHandler():GetControler()
	return not c:IsLocation(0x80) and c:GetOwner()==1-tp
end
