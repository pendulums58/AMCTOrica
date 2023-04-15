--테일테이머 디자인
function c101238007.initial_effect(c)
	--서로 회수하기
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101238007.condition)
	e1:SetCountLimit(1,101238007)
	e1:SetTarget(c101238007.target)
	e1:SetOperation(c101238007.activate)
	c:RegisterEffect(e1)
	--자체 부활 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,101238107)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c101238007.spcost)
	e2:SetTarget(c101238007.sptg)
	e2:SetOperation(c101238007.spop)
	c:RegisterEffect(e2)
end
function c101238007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101238007.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101238007.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x619) and c:IsType(TYPE_SYNCHRO)
end
function c101238007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101238007.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101238007.thfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_GRAVE)		
end
function c101238007.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c101238007.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101238007.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(1-tp,c101238007.thfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 and g1:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
	end
end
function c101238007.rmfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x619) and c:IsAbleToRemoveAsCost()
end
function c101238007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101238007.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101238007.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101238007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),Duel.ReadCard(tc,CARDDATA_SETCODE),TYPES_NORMAL_TUNER_MONSTER,500,500,3,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c101238007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
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