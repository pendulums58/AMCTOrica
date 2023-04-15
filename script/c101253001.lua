--액세스 코드『흑백』
function c101253001.initial_effect(c)
	--흑백 속공 서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101253001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,101253001)
	e1:SetCost(c101253001.scost)
	e1:SetTarget(c101253001.target)
	e1:SetOperation(c101253001.operation)
	c:RegisterEffect(e1)
	--흑백 몬스터 서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101253001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,101253101)
	e2:SetCost(c101253001.scost1)
	e2:SetTarget(c101253001.target1)
	e2:SetOperation(c101253001.operation1)
	c:RegisterEffect(e2)
	--흑백으로 소환시 엑시즈 효과
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101253001,1))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c101253001.con)
	e3:SetOperation(c101253001.operation2)
	c:RegisterEffect(e3)	
end
function c101253001.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101253001.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101253001.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c101253001.costfilter(c)
	return c:IsSetCard(0x60b) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c101253001.filter(c)
	return c:IsSetCard(0x60b) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c101253001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101253001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101253001.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101253001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101253001.scost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101253001.costfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101253001.costfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c101253001.costfilter1(c)
	return c:IsSetCard(0x60b) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToRemoveAsCost()
end
function c101253001.filter1(c)
	return c:IsSetCard(0x60b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101253001.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101253001.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101253001.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101253001.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101253001.con(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x60b)
end
function c101253001.operation2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101253001.xyzlv)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c101253001.xyzlv(e,c,rc)
	return 0x50000+e:GetHandler():GetLevel()
end