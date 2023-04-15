--벽영의 관리자
c111310111.AccessMonsterAttribute=true
function c111310111.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310111.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310111.con1)
	e1:SetOperation(c111310111.thop1)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(cyan.nacon)
	c:RegisterEffect(e2)	
	--대상이 되지 않는다
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_ACCESS))
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c111310111.efilter)	
	c:RegisterEffect(e3)
	--효과를 받지 않는다
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cyan.nacon)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x605))
	e4:SetValue(c111310111.efilter1)
	c:RegisterEffect(e4)
	--어드민 덤핑
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(111310092,3))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetCondition(c111310111.tdcon)
	e5:SetOperation(c111310111.rmop)
	c:RegisterEffect(e5)	
end
function c111310111.afil1(c)
	return c:IsRace(RACE_CREATORGOD)
end
function c111310111.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310111.thop1(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 푸른 그림자의 관리자가 탄생했습니다.")
end
function c111310111.efilter(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_MONSTER)
end
function c111310111.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c111310111.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad and tp~=Duel.GetTurnPlayer()
end
function c111310111.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end