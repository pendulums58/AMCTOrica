--뇌명, 우레와 함께 흐르는
function c101262002.initial_effect(c)
	--앞면 세팅
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101262002,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101262002)
	e1:SetTarget(c101262002.tftg)
	e1:SetOperation(c101262002.tfop)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	c:RegisterEffect(e2)
	--충전 효과
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetCode(EFFECT_RAIMEI_IM)
	e3:SetCondition(c101262002.drcon)
	e3:SetTarget(c101262002.drtg)
	e3:SetOperation(c101262002.drop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101262002,ACTIVITY_CHAIN,c101262002.chainfilter)
end
function c101262002.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(56260110)
end
function c101262002.tffilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS+TYPE_FIELD) and c:IsSetCard(0x62d) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c101262002.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101262002.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c101262002.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c101262002.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		loc=LOCATION_SZONE
		if tc:IsType(TYPE_FIELD) then loc=LOCATION_FZONE end
		Duel.MoveToField(tc,tp,tp,loc,POS_FACEUP,true)
	end
end
function c101262002.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101262002,tp,ACTIVITY_CHAIN)~=0
end
function c101262002.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,56260110)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c101262002.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,56260110)
	local ct1=Duel.Draw(p,ct,REASON_EFFECT)
	if ct1>0 then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,ct,ct,nil)
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end