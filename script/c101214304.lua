--스카이워커 럭스
function c101214304.initial_effect(c)
	--레벨 상승
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101214304)
	e1:SetCost(cyan.selfdiscost)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101214304.lvtg)
	e1:SetOperation(c101214304.lvop)
	c:RegisterEffect(e1)
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c101214304.spcon)
	e2:SetCountLimit(1,101214404)
	e2:SetTarget(c101214304.sptg)
	e2:SetOperation(c101214304.spop)
	c:RegisterEffect(e2)
end
function c101214304.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101214304.chk(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c101214304.chk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tc=Duel.SelectTarget(tp,c101214304.chk,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101214304.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(6)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)			
	end
end
function c101214304.chk(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c101214304.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101214304.chk1,1,nil)
end
function c101214304.chk1(c)
	return c:GetLevel()~=c:GetPreviousLevelOnField()
end
function c101214304.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function c101214304.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end