--PM(프로토콜 마스터).2e 트래픽 페네트레이터
c111310011.AccessMonsterAttribute=true
c111310011.ProtocolMasterNumber=46
function c111310011.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310011.afil1,c111310011.afil2)
	c:EnableReviveLimit()
	--공뻥
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c111310011.atkval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c111310011.defval)
	c:RegisterEffect(e2)
	--효과 무효
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c111310011.distg)
	c:RegisterEffect(e3)
	--마함 쓸이
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(111310011,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetTarget(c111310011.thtg)
	e4:SetOperation(c111310011.thop)
	c:RegisterEffect(e4)	
end
function c111310011.afil1(c)
	local tp=c:GetControler()
	local lv=c:GetAttack()
	return not Duel.IsExistingMatchingCard(c111310011.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lv)
end
function c111310011.afil2(c)
	return c:GetLevel()>0
end
function c111310011.cfilter(c,ml)
	return c:IsFaceup() and c:GetAttack()<ml
end
function c111310011.atkval(e,c)
	local ad=e:GetHandler():GetAdmin()
	if ad then return (ad:GetAttack())/2 end
	return 0
end
function c111310011.defval(e,c)
	local ad=e:GetHandler():GetAdmin()
	if ad then return (ad:GetDefense())/2 end
	return 0
end
function c111310011.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c111310011.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c111310011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c111310011.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c111310011.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c111310011.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c111310011.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end