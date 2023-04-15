--멸갈의 관리자
c111310037.AccessMonsterAttribute=true
function c111310037.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,c111310037.afilter)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310037.con)
	e1:SetOperation(c111310037.thop1)
	c:RegisterEffect(e1)
	--공뻥
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(1)
	e3:SetCondition(c111310037.rcon)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetValue(1)
	e4:SetCondition(c111310037.rcon)
	c:RegisterEffect(e4)
	--창조신족
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_RACE)
	e5:SetValue(RACE_CREATORGOD)
	e5:SetCondition(c111310037.rcon)
	c:RegisterEffect(e5)
	--어드민 제거
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetDescription(aux.Stringid(111310037,2))
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c111310037.rmcon)
	e6:SetCost(c111310037.cost)
	e6:SetOperation(c111310037.rmop)
	c:RegisterEffect(e6)	
end
function c111310037.afilter(c)
	return c:IsType(TYPE_NORMAL)
end
function c111310037.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310037.thop1(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 베이지색의 관리자가 감지되었습니다.")
end
function c111310037.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c111310037.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad
end
function c111310037.costfilter(c)
	return c:IsFaceup() and c:GetAttack()>=2500
end
function c111310037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c111310037.costfilter,1,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c111310037.costfilter,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c111310037.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end