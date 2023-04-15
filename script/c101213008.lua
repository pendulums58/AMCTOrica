--승연하는 쉼터
function c101213008.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--1번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xef3))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	
	--2번 효과
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(c101213008.cost)
	e3:SetTarget(c101213008.target)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetOperation(c101213008.activate)
	c:RegisterEffect(e3)
	
	--3번 효과
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCost(c101213008.cost2)
	e4:SetCondition(c101213008.spcon)
	e4:SetTarget(c101213008.tar)
	e4:SetOperation(c101213008.act)
	c:RegisterEffect(e4)
end
function c101213008.qfilter1(c)
	return c:IsSetCard(0xef3) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_GRAVE)
end
function c101213008.qfilter2(c,e,tp)
	return c101213008.qfilter1(c)
		and Duel.IsExistingMatchingCard(c101213008.qfilter3,tp,LOCATION_GRAVE,0,1,c,e,tp,c)
end
function c101213008.qfilter3(c,e,tp,rc)
	local g=Group.FromCards(c,rc)
	return Duel.IsExistingTarget(c101213008.qfilter4,tp,LOCATION_GRAVE,0,1,g,e,tp)
end
function c101213008.qfilter4(c,e,tp,zone)
	return c:IsSetCard(0xef3) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,zone)
end
function c101213008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=Duel.GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213008.qfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c101213008.qfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c101213008.qfilter3,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c101213008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=Duel.GetLinkedZone(tp)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101213008.qfilter4(chkc,e,tp,zone) end
	if chk==0 then return zone~=0 and Duel.IsExistingTarget(c101213008.qfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101213008.qfilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101213008.activate(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c101213008.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c101213008.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	e:SetLabel(tc:GetCode())
	return eg:GetCount()==1
		and tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsReason(REASON_BATTLE+REASON_EFFECT)
		and tc:IsType(TYPE_LINK) and tc:IsControler(tp) and tc:IsSetCard(0xef3) and eg:IsExists(c101213008.cfilter,1,nil,e,tp)
end
function c101213008.cfilter(c,e,tp)
	return Duel.IsExistingTarget(c101213008.filter2,tp,LOCATION_GRAVE,0,1,nil,c:GetLink(),e,tp)
end
function c101213008.filter2(c,lv,e,tp)
	return c:GetLink()>0 and c:GetLink()==lv-1 and c:IsSetCard(0xef3)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101213008.tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101213008.filter2(chkc,eg:GetFirst():GetLink(),e,tp) end
	if chk==0 then return eg:IsExists(c101213008.cfilter,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101213008.filter2,tp,LOCATION_GRAVE,0,1,1,nil,eg:GetFirst():GetLink(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101213008.act(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end