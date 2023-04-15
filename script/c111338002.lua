--R-PINE 셸
function c111338002.initial_effect(c)
--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111333002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,111333002)
	e1:SetCondition(c111338002.con)	
	e1:SetCost(c111338002.thcost)
	e1:SetTarget(c111338002.thtg)
	e1:SetOperation(c111338002.thop)
	c:RegisterEffect(e1)	
--묘지 특소
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111333002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,111333502)
	e2:SetCondition(c111338002.spcon)
	e2:SetTarget(c111338002.sptg)
	e2:SetOperation(c111338002.spop)
	c:RegisterEffect(e2)		
end
--서치
function c111338002.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c111338002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c111338002.thfilter(c)
	return c:IsSetCard(0x656) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c111338002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c111338002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111338002.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111338002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--묘지 특소
function c111338002.spfilter(c,tp)
	local ty=c:GetPreviousTypeOnField()
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and bit.band(ty,TYPE_SYNCHRO)==TYPE_SYNCHRO
end
function c111338002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp 
	and eg:IsExists(c111338002.spfilter,1,nil,tp)
end
function c111338002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c111338002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end