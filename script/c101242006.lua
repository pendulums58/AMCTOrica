--니르바나 메모리콜러
function c101242006.initial_effect(c)
	--펜듈럼 속성
	aux.EnablePendulumAttribute(c,false)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c101242006.synfilter1),1)
	c:EnableReviveLimit()
	--파괴 내성 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101242006.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101242006,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c101242006.salcon)
	e2:SetTarget(c101242006.saltg)
	e2:SetOperation(c101242006.salop)
	c:RegisterEffect(e2)
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101242006,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101242006.thcon1)
	e3:SetTarget(c101242006.thtg1)
	e3:SetOperation(c101242006.thop1)
	c:RegisterEffect(e3)
	--펜듈럼 세팅	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c101242006.pencon)
	e4:SetTarget(c101242006.pentg)
	e4:SetOperation(c101242006.penop)
	c:RegisterEffect(e4)	
end
function c101242006.synfilter1(c)
	return c:IsSetCard(0x61c)
end
function c101242006.indtg(e,c)
	return c:IsType(TYPE_PENDULUM)
end
function c101242006.salcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c101242006.thfilter(c)
	return c:IsAbleToHand()
end
function c101242006.saltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101242006.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101242006.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101242006.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101242006.salop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101242006.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) or (Duel.IsPlayerAffectedByEffect(tp,101242009) and e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM))
end
function c101242006.thfilter1(c)
	return c:IsSetCard(0x61c) and c:IsAbleToHand()
end
function c101242006.thchk(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c101242006.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE
	if Duel.IsExistingMatchingCard(c101242006.thchk,tp,LOCATION_EXTRA,0,1,nil) then loc=loc+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c101242006.thfilter1,tp,loc,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c101242006.thop1(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_GRAVE
	if Duel.IsExistingMatchingCard(c101242006.thchk,tp,LOCATION_EXTRA,0,1,nil) then loc=loc+LOCATION_DECK end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101242006.thfilter1,tp,loc,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101242006.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101242006.penfilter(c)
	return c:IsSetCard(0x61c) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup()
end
function c101242006.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101242006.penfilter,tp,LOCATION_EXTRA,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c101242006.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c101242006.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end