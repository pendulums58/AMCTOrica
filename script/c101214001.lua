--스카이워커 베이퍼
function c101214001.initial_effect(c)
	--튜너 존재시 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101214001.spcon)
	c:RegisterEffect(e1)
	--레벨 증가 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25788011,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c101214001.target)
	e2:SetOperation(c101214001.operation)
	c:RegisterEffect(e2)	
	--소재가 되면 LRM 덤핑
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112400506,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetCountLimit(1,101214001)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(c101214001.drcon)
	e3:SetTarget(c101214001.target1)
	e3:SetOperation(c101214001.operation1)	
	c:RegisterEffect(e3)
end
function c101214001.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsSetCard(0xef5)
end
function c101214001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c101214001.filter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c101214001.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c101214001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101214001.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101214001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101214001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101214001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local lv=Duel.SelectOption(tp,aux.Stringid(25788011,1),aux.Stringid(25788011,2),aux.Stringid(25788011,3))
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(lv+1)
		tc:RegisterEffect(e1)
	end
end
function c101214001.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c101214001.filter1(c)
	return c:IsSetCard(0x9ec7) and c:IsAbleToGrave()
end
function c101214001.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101214001.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101214001.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101214001.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end