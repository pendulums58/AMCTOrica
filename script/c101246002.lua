--진원기록『그림자』
function c101246002.initial_effect(c)
	--자신 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101246002,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101246002)
	e1:SetCost(c101246002.spcost)
	e1:SetCondition(c101246002.spcon)
	e1:SetTarget(c101246002.sptg)
	e1:SetOperation(c101246002.spop)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--2000 데미지
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101246002,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101246002.damcon)
	e3:SetTarget(c101246002.damtg)
	e3:SetOperation(c101246002.damop)
	c:RegisterEffect(e3)
	--묘지 회수
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101246002,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c101246002.thcon)
	e4:SetTarget(c101246002.thtg)
	e4:SetOperation(c101246002.thop)
	c:RegisterEffect(e4)
end
function c101246002.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL) and rc~=c
		and rc:IsType(TYPE_QUICKPLAY) and rc:GetControler()==tp
end
function c101246002.cfilter(c,tp)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
end
function c101246002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101246002.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c101246002.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101246002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101246002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101246002.cfilter1(c,tp)
	return c:IsControler(1-tp)
end
function c101246002.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101246002.cfilter1,1,nil,tp)
end
function c101246002.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c101246002.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c101246002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():GetPreviousControler()==tp
end
function c101246002.filter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c101246002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c101246002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101246002.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101246002.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101246002.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end