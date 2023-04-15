--근원에 달하는 니르바나
function c101242009.initial_effect(c)
	--발동시 효과 처리
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101242009)
	e1:SetOperation(c101242009.activate)
	c:RegisterEffect(e1)
	--니르바나 ON
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(101242009)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--대상 내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c101242009.con)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--대상내성 해제 트리거
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c101242009.tgcon)
	e4:SetOperation(c101242009.tgop)
	c:RegisterEffect(e4)
end
function c101242009.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x61c) and not c:IsForbidden()
end
function c101242009.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101242009.filter,tp,LOCATION_DECK,0,nil)
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
	if ct>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101242009,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		while sc do
			Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			sc=sg:GetNext()
		end
	end
end
function c101242009.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(101242009)==0
end
function c101242009.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101242009.tgfilter,1,nil,tp)
end
function c101242009.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x61c) and c:IsControler(tp)
end
function c101242009.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:RegisterFlagEffect(101242009,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end