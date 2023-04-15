--희망을 옮기는 방주
function c111310118.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310118.afilter1,c111310118.afilter2)
	c:EnableReviveLimit()		
	--Arknights
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c111310118.aktg)
	e1:SetOperation(c111310118.akop)
	c:RegisterEffect(e1)
	--묘지로 보낸다
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c111310118.tg)
	e2:SetOperation(c111310118.op)
	c:RegisterEffect(e2)
end
function c111310118.afilter1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c111310118.afilter2(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c111310118.aktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsSummonType(SUMMON_TYPE_SPECIAL) end
	if chk==0 then return c:GetAdmin()==nil and Duel.IsExistingTarget(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_SPECIAL) end
	local tc=Duel.SelectTarget(tp,Card.IsSummonType,tp,LOCATION_MZONE,0,1,1,nil,SUMMON_TYPE_SPECIAL)
end
function c111310118.akop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) or c:GetAdmin()~=nil then return end
	Duel.Overlay(c,tc)
end
function c111310118.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAdmin()~=nil end
end
function c111310118.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler():GetAdmin(),REASON_EFFECT)
end