--패러리얼 패스메이커
function c101244002.initial_effect(c)
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101244002.adtg)
	e1:SetOperation(c101244002.adop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--융합 소재시
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101244002,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c101244002.condition)
	e2:SetTarget(c101244002.target)
	e2:SetOperation(c101244002.operation)
	c:RegisterEffect(e2)
end
function c101244002.filter(c)
	return bit.band(c:GetReason(),0x40008)==0x40008 and c:IsAbleToHand()
end
function c101244002.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c101244002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101244002.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101244002.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101244002.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
function c101244002.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsType(TYPE_FUSION)
end
function c101244002.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(1-tp) and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c101244002.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101244002.cfilter,1,nil)
end
function c101244002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=eg:Filter(c101244002.cfilter,nil)
	local g=Group.CreateGroup()
	local mc=mg:GetFirst()
	while mc do
		g:Merge(mc:GetMaterial())
		mc=mg:GetNext()
	end
	if chkc then return g:IsContains(chkc) and c101244002.spfilter(chkc,e,tp) end
	if chk==0 then return g:IsExists(c101244002.spfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:FilterSelect(tp,c101244002.spfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101244002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end