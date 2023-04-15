--라일락의 관리자
c101241001.AccessMonsterAttribute=true
function c101241001.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241001.afil1,c101241001.afil2)
	c:EnableReviveLimit()
	
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101241001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101241001.con)
	e1:SetOperation(c101241001.thop)
	c:RegisterEffect(e1)
	
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(c101241001.rcon)
	c:RegisterEffect(e2)
	
	--무효
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101241001,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101241001.negcon)
	e3:SetTarget(c101241001.negtg)
	e3:SetOperation(c101241001.negop)
	c:RegisterEffect(e3)
	--무한포영
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_DISABLE)
	e4:SetCondition(c101241001.negcon2)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e4:SetTarget(c101241001.distg)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetCondition(c101241001.negcon2)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e5:SetTarget(c101241001.distg)
    c:RegisterEffect(e5)
	
	--공격력 업
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(c101241001.atkup)
	c:RegisterEffect(e6)
	
	--어드민 덤핑
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(101241001,2))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c101241001.tdcon)
	e7:SetOperation(c101241001.rmop)
	c:RegisterEffect(e7)	
end
function c101241001.afil1(c)
	return c:IsType(TYPE_ACCESS)
end
function c101241001.afil2(c)
	return c:IsRace(RACE_PSYCHO)
end
function c101241001.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101241001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,nil,e:GetDescription())
end 
function c101241001.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c101241001.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c101241001.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101241001.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c101241001.negcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c101241001.sfilter(c,seq,tp,rp)
	local p=c:GetControler()
	return c:GetColumnGroupCount()>0 and ((p==tp and c:GetSequence()==seq) or (p==1-tp and c:GetSequence()==4-seq))
end
function c101241001.distg(e,c)
    local tp=e:GetHandlerPlayer()
    local rp=c:GetControler()
    local seq=c:GetSequence()
    return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and Duel.IsExistingMatchingCard(c101241001.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,seq,rp)
		and not c:IsSetCard(101241001)
end
function c101241001.filter(c)
	return c:IsDisabled()
end
function c101241001.atkup(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c101241001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*300
end
function c101241001.desfilter(c,col)
	return col==aux.GetColumn(c)
end
function c101241001.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	local col=aux.GetColumn(e:GetHandler())
	return ad and col and Duel.IsExistingMatchingCard(c101241001.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,nil,col)
end
function c101241001.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end