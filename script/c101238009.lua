--테일테이머 시타기리
function c101238009.initial_effect(c)
	--마법 카드 구현화
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101238009.spcon)
	e1:SetTarget(c101238009.sptg)
	e1:SetOperation(c101238009.spop)
	c:RegisterEffect(e1)	
	--서로 덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101238009)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c101238009.tgtg)
	e2:SetOperation(c101238009.tgop)
	c:RegisterEffect(e2)
end
function c101238009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c101238009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),Duel.ReadCard(tc,CARDDATA_SETCODE),TYPES_NORMAL_TUNER_MONSTER,500,500,3,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c101238009.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=re:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		c:CancelToGrave()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER+TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_SPELL)
		c:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_LIGHT)
		c:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(500)
		c:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(500)
		c:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_RACE)
		e6:SetValue(RACE_FAIRY)
		c:RegisterEffect(e6,true)
		local e7=e1:Clone()
		e7:SetCode(EFFECT_CHANGE_LEVEL)
		e7:SetValue(3)
		c:RegisterEffect(e7,true)		
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)		
	end
end
function c101238009.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c101238009.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101238009.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101238009.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101238009.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(1-tp,c101238009.tgfilter,tp,0,LOCATION_DECK,1,1,nil)
	g:Merge(g1)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
