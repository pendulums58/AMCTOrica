--아주르 나이트패스
function c101223026.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223026.pfilter,c101223026.mfilter,2,2)
	c:EnableReviveLimit()	
	--직접 공격
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c101223026.con)
	c:RegisterEffect(e1)	
end
function c101223026.pfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c101223026.mfilter(c,pair)
	return c:GetLevel()==pair:GetLevel() and pair:GetLevel()>0
end
function c101223026.con(e,c)
	return e:GetHandler():GetPairCount()>0
end