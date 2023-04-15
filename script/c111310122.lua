--용고의 관리자
function c111310122.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310122.afil1,c111310122.afil2)
	c:EnableReviveLimit()	
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310122.con1)
	e1:SetOperation(c111310122.thop1)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(cyan.nacon)
	c:RegisterEffect(e2)
	--패 매수 제한
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_HAND_LIMIT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(4)
	c:RegisterEffect(e3)
	--번개왕
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TO_HAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cyan.nacon)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	c:RegisterEffect(e4)	
	--어드민 덤핑
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(111310122,3))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetCondition(c111310122.tdcon)
	e5:SetOperation(c111310122.rmop)
	c:RegisterEffect(e5)
end
function c111310122.afil1(c)
	return c:IsType(TYPE_ACCESS) and c:IsSetCard(0x605)
end
function c111310122.afil2(c)
	return c:IsType(TYPE_ACCESS) and c:IsLevelAbove(10)
end
function c111310122.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310122.thop1(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 용의 의지를 가진 관리자가 탄생했습니다.")
end
function c111310122.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad~=nil and tp~=Duel.GetTurnPlayer()
end
function c111310122.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end