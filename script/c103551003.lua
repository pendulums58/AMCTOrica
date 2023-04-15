--휘환성봉 버밀리온
function c103551003.initial_effect(c)
	--소환시 샐비지
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,103551003)
	cyan.JustSearch(e1,LOCATION_GRAVE,c103551003.thfilter,1)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e0)
	--장착 조건 무시
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_EQUIP_IGNORE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetValue(1)
	e2:SetRange(0xff)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e2)	
	--내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c103551003.indtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c103551003.thfilter(c,val)
	return (c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)) or c:IsSetCard(0x64b)
end
function c103551003.indtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
