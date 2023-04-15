--포토니아 스래셔
function c101241018.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101241018.pfilter,c101241018.mfilter,2,2)
	c:EnableReviveLimit()
	--공격 불가 및 액세스 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetCondition(c101241018.atcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_ACCESS_MATERIAL)
	c:RegisterEffect(e2)
	--뒷면 후 앞면
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101241018.thcon)
	e3:SetTarget(c101241018.thtg)
	e3:SetOperation(c101241018.thop)
	c:RegisterEffect(e3)
	--페어로 한다
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c101241018.destg)
	e4:SetOperation(c101241018.desop)
	c:RegisterEffect(e4)
end
function c101241018.pfilter(c)
	return c:IsType(TYPE_EFFECT)
end
function c101241018.mfilter(c,pair)
	return c:IsRace(pair:GetRace()) and c:IsLevelAbove(pair:GetLevel())
end
function c101241018.atcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
function c101241018.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PAIRING)
end
function c101241018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c101241018.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE) then
			Duel.BreakEffect()
			Duel.ChangePosition(c,POS_FACEUP_ATTACK)
		end
	end
end
function c101241018.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
end
function c101241018.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		e:GetHandler():SetPair(tc)
	end
end