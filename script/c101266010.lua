--유니에이트 로스트윙
function c101266010.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101266010.pfilter,c101266010.mfilter,2,2)
	c:EnableReviveLimit()	
	--카운터
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101266010,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101266010.con)
	e1:SetOperation(c101266010.addc)
	c:RegisterEffect(e1)
	--공격 대상 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101266010.ctcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)	
	--직접 공격
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCondition(c101266010.ctcon)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--파괴 대체
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c101266010.reptg)
	e4:SetOperation(c101266010.repop)
	c:RegisterEffect(e4)
end
function c101266010.pfilter(c)
	return c:IsSetCard(0x634) and c:IsLevelBelow(4)
end
function c101266010.mfilter(c,pair)
	return c:GetAttribute()==pair:GetAttribute()
end
function c101266010.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PAIRING)
end
function c101266010.addc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) then
		local ct=c:GetPair():GetSum(Card.GetLevel,nil)
		e:GetHandler():AddCounter(0x1324,ct)
	end
end
function c101266010.ctcon(e)
	return e:GetHandler():GetCounter(0x1324)>0
end
function c101266010.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT+REASON_PAIR) and not c:IsReason(REASON_REPLACE)
		and c:IsCanRemoveCounter(tp,0x1324,1,REASON_EFFECT)
	end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c101266010.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1324,1,REASON_EFFECT)
end