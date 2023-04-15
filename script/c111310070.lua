--라이프라이트 캔들
c111310070.AccessMonsterAttribute=true
function c111310070.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310070.afil1,c111310070.afil2)
	c:EnableReviveLimit()
	--하이잭
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_HIIJACK_ACCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c111310070.hijack)
	c:RegisterEffect(e1)	
end
function c111310070.afil1(c)
	return c:IsRace(RACE_FIRE)
end
function c111310070.afil2(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c111310070.hijack(e,acc,hj)
	return hj:IsLevel(4)
end