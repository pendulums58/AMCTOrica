--창성의 관리자
c101248008.AccessMonsterAttribute=true
function c101248008.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101248008.afil1,c101248008.afil2)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101248008.con)
	e1:SetOperation(c101248008.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(cyan.nacon)
	c:RegisterEffect(e2)
	--레벨 변경
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(11)
	c:RegisterEffect(e3)
	--무효
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101248008,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c101248008.condition1)
	e4:SetTarget(c101248008.target)
	e4:SetOperation(c101248008.operation)
	c:RegisterEffect(e4)
	--어드민 떨구기
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101248008,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c101248008.cost)
	e5:SetOperation(c101248008.operation)
	c:RegisterEffect(e5)
end
function c101248008.afil1(c)
	return c:IsType(TYPE_ACCESS)
end
function c101248008.afil2(c)
	return c:IsSetCard(0x622)
end
function c101248008.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101248008.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 쪽빛의 관리자가 모습을 드러냈습니다.")
end
function c101248008.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and rc:GetLevel()~=11 and c:GetAdmin()==nil
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c101248008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c101248008.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	end
end
function c101248008.cfilter(c)
	return c:IsSetCard(0xfe,0x620) and c:IsAbleToGraveAsCost()
end
function c101248008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101248008.cfilter,tp,LOCATION_DECK,0,1,nil)
		and e:GetHandler():GetAdmin()~=nil end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101248008.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101248008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end