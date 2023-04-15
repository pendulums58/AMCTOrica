--BST 이코노클라즘
function c101261010.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.FilterBoolFunction(Card.IsType,TYPE_TUNER),1,99)
	c:EnableReviveLimit()	
	--릴리스 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c101261010.rellimit)
	c:RegisterEffect(e1)
	--대상 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,BLANK_NAME))
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
	--공백의 이름 체크
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c101261010.chk)
	c:RegisterEffect(e3)
	--묘지 회수 효과
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetLabelObject(e3)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101261010)
	e4:SetCondition(c101261010.con4)
	e4:SetTarget(c101261010.target)
	e4:SetOperation(c101261010.operation)
	c:RegisterEffect(e4)
	--파괴시 유언 효과
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101261010,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(c101261010.spcon)
	e5:SetOperation(c101261010.spop)
	c:RegisterEffect(e5)
end
function c101261010.rellimit(e,c,tp,sumtp)
	return c:IsCode(BLANK_NAME)
end
function c101261010.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousControler(tp)
end
function c101261010.filter2(c)
	return c:IsFaceup() and c:IsCode(BLANK_NAME)
end
function c101261010.chk(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101261010.filter2,nil)
	if g:GetCount()>0 then e:SetLabel(1)
	else e:SetLabel(0)
	end
end
function c101261010.con4(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():GetLabel()
	return g>0
end
function c101261010.nfil4(c,g)
	return g and g:IsContains(c) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c101261010.filter1(c)
	return c:IsSetCard(0x62b) and c:IsAbleToHand()
end
function c101261010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c101261010.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101261010.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101261010.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101261010.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101261010.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
end
function c101261010.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(101261000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end