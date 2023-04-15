--PM(프로토콜 마스터).f 세컨더리 파일럿
c111310041.AccessMonsterAttribute=true
c111310041.ProtocolMasterNumber=16
function c111310041.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310041.afil1,c111310041.afil2)
	c:EnableReviveLimit()
	--직접 공격
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--데미지
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310041,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c111310041.condition)
	e2:SetTarget(c111310041.target)
	e2:SetOperation(c111310041.operation)
	c:RegisterEffect(e2)
	--파괴 대체
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c111310041.reptg)
	c:RegisterEffect(e3)
end
function c111310041.afil1(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c111310041.afil2(c)
	return c:GetSequence()==2
end
function c111310041.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c111310041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad==nil then return true end
	if ad:GetAttack()==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ad:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ad:GetAttack())
end
function c111310041.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c111310041.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAdmin() end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local ad=e:GetHandler():GetAdmin()
		Duel.SendtoGrave(ad,REASON_EFFECT)
		return true
	else return false end
end