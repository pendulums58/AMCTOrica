--PM(프로토콜 마스터).35 폴스 게이트키퍼
c111310024.AccessMonsterAttribute=true
c111310024.ProtocolMasterNumber=53
function c111310024.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()
	--소환 무효 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetCondition(c111310024.effcon)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--소환시 발동 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c111310024.effcon2)
	e2:SetOperation(c111310024.spsumsuc)
	c:RegisterEffect(e2)
	--효과 보호
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c111310024.effectfilter)
	e3:SetCondition(c111310024.effcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e4)
	--어드민 주입
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c111310024.target)
	e5:SetOperation(c111310024.operation)
	c:RegisterEffect(e5)
end
function c111310024.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310024.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310024.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c111310024.chlimit)
end
function c111310024.chlimit(e,ep,tp)
	return tp==ep
end
function c111310024.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
end
function c111310024.filter(c)
	return c:IsType(TYPE_ACCESS) and not c:GetAdmin()
end
function c111310024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c111310024.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c111310024.filter,tp,LOCATION_MZONE,0,1,nil,tp) and c:GetAdmin() end
	local g=Duel.SelectTarget(tp,c111310024.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c111310024.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetAdmin()==nil and c:GetAdmin() then
		local ad=c:GetAdmin()
		Duel.Overlay(tc,ad)
	end
end