--현계의 잔불여우
local s,id=GetID()
function s.initial_effect(c)
	--일특소시 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tktg)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.thcon)
	Cyan.JustSearch(e3,LOCATION_DECK,Card.IsSetCard,0x638)
	c:RegisterEffect(e3)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Cyan.EmberTokenCheck(tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	if s.tktg(e,tp,eg,ep,ev,re,r,rp,0) then
		local c=e:GetHandler()
		local token=Cyan.CreateEmberToken(tp)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Cyan.AddEmberTokenAttribute(token)
	end
	Duel.SpecialSummonComplete()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousControler,1,nil,tp)
end