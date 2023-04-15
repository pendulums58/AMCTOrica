--니르바나 시즌메이커
function c101242007.initial_effect(c)
	--펜듈럼 속성
	aux.EnablePendulumAttribute(c,false)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1)
	c:EnableReviveLimit()
	--무효화 처리
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c101242007.negcon)
	e1:SetOperation(c101242007.negop)
	c:RegisterEffect(e1)
	--대신 파괴
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c101242007.reptg)
	e2:SetValue(c101242007.repval)
	e2:SetOperation(c101242007.repop)
	c:RegisterEffect(e2)	
	--싱크로 소환시
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101242007,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,101242007)
	e3:SetCondition(c101242007.thcon)
	cyan.JustSearch(e3,LOCATION_DECK,Card.IsSetCard,0x61c)
	c:RegisterEffect(e3)
	--마법 무효
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101242007,0))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,101242107)
	e4:SetCondition(c101242007.condition)
	e4:SetTarget(c101242007.target)
	e4:SetOperation(c101242007.activate)
	c:RegisterEffect(e4)	
end
function c101242007.cfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x61c) and c:IsFaceup() and c:GetControler()==tp
end
function c101242007.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c101242007.cfilter,1,nil,tp) and rp==1-tp
end
function c101242007.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101242007)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local ct=g:FilterCount(c101242007.cfilter,nil)
	local rc=re:GetHandler()
	if ct>0 and Duel.CheckLPCost(1-tp,2000*ct) and Duel.SelectYesNo(1-tp,aux.Stringid(101242007,0)) then
		
	else
		Duel.NegateEffect(ev)
	end
end
function c101242007.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_SYNCHRO)
		and (c:IsReason(REASON_PAIR) or c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and not c:IsReason(REASON_REPLACE)
end
function c101242007.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c101242007.repfilter,1,c,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c101242007.repval(e,c)
	return c101242007.repfilter(c,e:GetHandlerPlayer())
end
function c101242007.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c101242007.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) or (Duel.IsPlayerAffectedByEffect(tp,101242009) and e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM))
end
function c101242007.filter(c,e,tp)
	return c:IsSetCard(0x61c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101242007.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c101242007.tpfilter(c)
	return c:IsSetCard(0x61c) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c101242007.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c101242007.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101242007.tpfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingTarget(c101242007.filter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101242007.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101242007.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x61c)
end
function c101242007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.SelectMatchingCard(tp,c101242007.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c101242007.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp
		and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c101242007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101242007.filter1,tp,LOCATION_MZONE+LOCAION_EXTRA,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101242007.filter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsSetCard(0x61c) and c:IsType(TYPE_SYNCHRO) and not c:IsForbidden()
end
function c101242007.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c101242007.filter1,tp,LOCATION_MZONE+LOCAION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 then
		Duel.NegateActivation(ev)
	end
end
