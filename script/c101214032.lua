--크로스카이워커 베이퍼
function c101214032.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(c101214032.synfilter),2)
	c:EnableReviveLimit()	
	--레벨 상승
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c101214032.con)
	e1:SetTarget(c101214032.lvtg)
	e1:SetOperation(c101214032.lvop)
	c:RegisterEffect(e1)
	--공뻥 및 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101214032.pfcon)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101214032.pfcon)
	e4:SetValue(3000)
	c:RegisterEffect(e4)
	--번 데미지
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101214032,0))
	e5:SetCategory(CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(c101214032.condition)
	e5:SetTarget(c101214032.target)
	e5:SetOperation(c101214032.operation)
	c:RegisterEffect(e5)	
end
function c101214032.synfilter(c)
	return c:IsSynchroType(TYPE_SYNCHRO) and c:IsSetCard(0xef5)
end
function c101214032.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c101214032.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101214032.lvfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetChainLimit(aux.FALSE)
end
function c101214032.lvfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xef5)
end
function c101214032.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c101214032.lvfilter,tp,LOCATION_GRAVE,0,nil)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c101214032.pfcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:GetLevel()>Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
end
function c101214032.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c101214032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c101214032.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=e:GetHandler():GetLevel()*100
	Duel.Damage(p,d,REASON_EFFECT)
end