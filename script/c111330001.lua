--조제의 잔불여우
function c111330001.initial_effect(c)
	--자신 특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,111330001)
	e1:SetCondition(c111330001.spcon)
	e1:SetTarget(c111330001.sptg)
	e1:SetOperation(c111330001.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--회복
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,111330101)
	e3:SetCondition(c111330001.thcon)
	e3:SetTarget(c111330001.tg)
	e3:SetOperation(c111330001.op)
	c:RegisterEffect(e3)
end
function c111330001.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
end
function c111330001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c111330001.cfilter,1,nil,tp)
end
function c111330001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c111330001.tkchk(c,tp)
	return c111330001.cfilter(c,tp) and c:IsType(TYPE_TOKEN)
end
function c111330001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 
		and eg:IsExists(c111330001.tkchk,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Cyan.EmberTokenCheck(tp)
		and Duel.SelectYesNo(tp,aux.Stringid(111330001,0)) then
			local token=Cyan.CreateEmberToken(tp)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			Cyan.AddEmberTokenAttribute(token)
			Duel.SpecialSummonComplete()
	end
end
function c111330001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousControler,1,nil,tp)
end
function c111330001.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function c111330001.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
