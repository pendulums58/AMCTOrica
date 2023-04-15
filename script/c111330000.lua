--현계의 잔불여우
function c111330000.initial_effect(c)
	--일특소시 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,111330000)
	e1:SetTarget(c111330000.tktg)
	e1:SetOperation(c111330000.tkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,111330100)
	e3:SetCondition(c111330000.thcon)
	Cyan.JustSearch(e3,LOCATION_DECK,Card.IsSetCard,0x638)
	c:RegisterEffect(e3)
end
function c111330000.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Cyan.EmberTokenCheck(tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c111330000.tkop(e,tp,eg,ep,ev,re,r,rp)
	if c111330000.tktg(e,tp,eg,ep,ev,re,r,rp,0) then
		local c=e:GetHandler()
		local token=Cyan.CreateEmberToken(tp)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Cyan.AddEmberTokenAttribute(token)
	end
	Duel.SpecialSummonComplete()
end
function c111330000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousControler,1,nil,tp)
end