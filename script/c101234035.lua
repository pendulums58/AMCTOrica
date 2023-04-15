--조 여환무장【얼라이언스】
function c101234035.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101234035.pfilter1,c101234035.pfilter2,1,1)
	c:EnableReviveLimit()
	--추가일소
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101234035,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x611))
	c:RegisterEffect(e1)
end
function c101234035.pfilter1(c)
	return c:IsSetCard(0x611) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c101234035.pfilter2(c)
	return c:IsSetCard(0x611)
end