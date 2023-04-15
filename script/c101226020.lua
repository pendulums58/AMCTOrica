--신살마녀 밀토니아
c101226020.AccessMonsterAttribute=true
function c101226020.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101226020.afil1,c101226020.afil2)
	c:EnableReviveLimit()
	--회복
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101226020)
	e1:SetCondition(c101226020.con)
	e1:SetTarget(c101226020.rectg)
	e1:SetOperation(c101226020.recop)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c101226020.destg)
	e2:SetOperation(c101226020.desop)
	c:RegisterEffect(e2)	
end
function c101226020.afil1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_ACCESS)
end
function c101226020.afil2(c)
	return c:IsSetCard(0x612)
end
function c101226020.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ACCESS
end
function c101226020.desfilter(c)
	return c:IsFaceup()
end
function c101226020.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttackAbove,tp,0,LOCATION_MZONE,1,nil,1) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local val=g:GetSum(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
	Duel.SetChainLimit(c101226020.chainlm)
end
function c101226020.chainlm(e,rp,tp)
	return tp==rp
end
function c101226020.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	local val=g:GetSum(Card.GetAttack)
		Duel.Recover(tp,val,REASON_EFFECT)
	end
end
function c101226020.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad==nil then return false end
	if chkc then return chkc:IsOnField() and c101226020.desfilter1(chkc,ad:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c101226020.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ad:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101226020.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ad:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101226020.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c101226020.desfilter1(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end