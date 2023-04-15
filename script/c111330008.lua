--잔불이 스러져가는 거리
function c111330008.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111330008)
	e1:SetTarget(c111330008.tg)
	e1:SetOperation(c111330008.op)
	c:RegisterEffect(e1)
	--토큰 특소
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c111330008.spcon)
	e2:SetTarget(c111330008.tktg)
	e2:SetOperation(c111330008.tkop)
	c:RegisterEffect(e2)
	--드로우
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c111330008.drcon)
	Cyan.JustDraw(e3,1)
	c:RegisterEffect(e3)
	--매수 카운트
	aux.GlobalCheck(c111330008,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c111330008.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function c111330008.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,TOKEN_EMBERFOX) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c111330008.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,TOKEN_EMBERFOX)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c111330008.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(111330008,0)) then
		local g=Duel.SelectMatchingCard(tp,c111330008.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c111330008.spfilter(c,e,tp)
	return c:IsSetCard(0x638) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c111330008.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	return (ex and tg~=nil) or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c111330008.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Cyan.EmberTokenCheck(tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c111330008.tkop(e,tp,eg,ep,ev,re,r,rp)
	if c111330008.tktg(e,tp,eg,ep,ev,re,r,rp,0) and e:GetHandler():IsRelateToEffect(e) then
		local c=e:GetHandler()
		local token=Cyan.CreateEmberToken(tp)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Cyan.AddEmberTokenAttribute(token)
	end
	Duel.SpecialSummonComplete()
end
function c111330008.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsReason(REASON_EFFECT) then
			Duel.RegisterFlagEffect(tc:GetPreviousControler(),111330008,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c111330008.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,111330004)>1
end