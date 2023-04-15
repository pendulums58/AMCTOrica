--빼앗긴 시계탑의 관리자
c101213308.AccessMonsterAttribute=true
function c101213308.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101213308.afil1,c101213308.afil2)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101213308.con)
	e1:SetOperation(c101213308.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(cyan.nacon)
	c:RegisterEffect(e2)
	--시계탑에 파괴 내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,75041269))
	e3:SetTargetRange(LOCATION_FZONE,0)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--전체 파괴 내성 획득
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cyan.nacon)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x60a))
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetValue(c101213308.indct)
	c:RegisterEffect(e4)
	--어드민 제거
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetDescription(aux.Stringid(101213308,1))
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c101213308.condition)
	e5:SetOperation(c101213308.rmop)
	c:RegisterEffect(e5)	
end
function c101213308.afil1(c)
	return c:IsSetCard(0x60a)
end
function c101213308.afil2(c)
	return c:GetLevel()==5
end
function c101213308.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101213308.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("\"나는, 어디로 가고 있는 걸까...?\"")
end
function c101213308.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c101213308.cfilter(c,ty)
	return c:IsSetCard(0x60a) and c:IsType(ty)
end
function c101213308.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101213308.cfilter,tp,LOCATION_GRAVE,0,1,nil,TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c101213308.cfilter,tp,LOCATION_GRAVE,0,1,nil,TYPE_SYNCHRO)
		and Duel.IsExistingMatchingCard(c101213308.cfilter,tp,LOCATION_GRAVE,0,1,nil,TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c101213308.cfilter,tp,LOCATION_GRAVE,0,1,nil,TYPE_LINK)
end
function c101213308.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end