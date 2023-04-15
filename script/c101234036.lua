--조 여환무장【내비게이트】
function c101234036.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101234036.pfilter1,c101234036.pfilter2,1,1)
	c:EnableReviveLimit()
	--효과대상불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101234036.tgtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--공격대상불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c101234036.tgtg)
	c:RegisterEffect(e2)
end
function c101234036.pfilter1(c)
	return c:IsSetCard(0x611) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c101234036.pfilter2(c)
	return c:IsSetCard(0x611)
end
function c101234036.tgtg(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
end