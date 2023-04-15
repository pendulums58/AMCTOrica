--시계탑의 저항자
c101213319.AccessMonsterAttribute=true
function c101213319.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101213319.afilter1,c101213319.afilter1)
	c:EnableReviveLimit()
	--시계탑에 대상 내성 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,CARD_CLOCKTOWER))
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--시계탑에 효과 해금
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(101213319)
	e2:SetCondition(c101213319.con)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
end
function c101213319.afilter1(c)
	return c:IsSetCard(0x60a)
end
function c101213319.con(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad and ad:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_ACCESS)
end