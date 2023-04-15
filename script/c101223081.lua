--별의 기사
function c101223081.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()	
	--싱크로 조건 변경
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101223081,0))
	e1:SetCountLimit(1,101223081)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynMixCondition(aux.Tuner(nil),c101223081.filter(c),nil,aux.NonTuner(nil),1,99))
	e1:SetTarget(Auxiliary.SynMixTarget(aux.Tuner(nil),c101223081.filter(c),nil,aux.NonTuner(nil),1,99))
	e1:SetOperation(Auxiliary.SynMixOperation(aux.Tuner(nil),c101223081.filter(c),nil,aux.NonTuner(nil),1,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_EXTRA,0)
	e2:SetTarget(c101223081.mattg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)	
	--효과 내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c101223081.indcon)
	e3:SetOperation(c101223081.indop)
	c:RegisterEffect(e3)
end
function c101223081.filter(tc)
	return function(c,syncard,c1)
		return c==tc
	end
end
function c101223081.mattg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_SYNCHRO)
end
function c101223081.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c101223081.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101223081,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(aux.indoval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
