--SNI 이스케이퍼
c111310038.AccessMonsterAttribute=true
function c111310038.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310038.afil1,c111310038.afil2)
	c:EnableReviveLimit()
	--하이잭
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_HIIJACK_ACCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c111310038.hijack)
	c:RegisterEffect(e1)
	--공뻥
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c111310038.atkval)
	c:RegisterEffect(e2)
	--몬스터 효과 내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c111310038.efilter)
	c:RegisterEffect(e3)
	--어드민으로 납치
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(111310038,0))
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCondition(aux.bdocon)
	e4:SetCost(c111310038.adcost)
	e4:SetTarget(c111310038.eqtg)
	e4:SetOperation(c111310038.eqop)
	c:RegisterEffect(e4)
end
function c111310038.afil1(c)
	return c:IsRace(RACE_CYBERSE+RACE_MACHINE+RACE_THUNDER)
end
function c111310038.afil2(c)
	return c:IsType(TYPE_LINK)
end
function c111310038.hijack(e,acc,hj)
	return hj:GetLevel()+acc:GetLevel()==12
end
function c111310038.atkval(e,c)
	local ad=e:GetHandler():GetAdmin()
	if ad then return ad:GetLevel()*100 end
	return 0
end
function c111310038.efilter(e,te)
	local tc=te:GetHandler()
	local ad=e:GetHandler():GetAdmin()
	if ad==nil then return false end
	return te:IsActiveType(TYPE_MONSTER) and (tc:GetAttack()<ad:GetAttack() or (tc:GetLevel()<ad:GetLevel() and not tc:IsType(TYPE_LINK+TYPE_XYZ))) and not tc==e:GetHandler()
end
function c111310038.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,bc,1,0,0)
end
function c111310038.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ad=e:GetHandler():GetAdmin()
	if chk==0 then return ad~=nil end
	Duel.SendtoGrave(ad,REASON_COST)
end
function c111310038.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and c:GetAdmin()==nil then
		Duel.Overlay(c,tc)
	end
end