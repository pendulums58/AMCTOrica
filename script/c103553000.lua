--방랑의 이나리소녀
function c103553000.initial_effect(c)
	aux.AddCodeList(c,103553000)
	--해금
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetRange(LOCATION_DECK)
	e0:SetTarget(c103553000.unlocktg)
	e0:SetOperation(c103553000.unlockop)
	c:RegisterEffect(e0)
	local ee=e0:Clone()
	ee:SetRange(LOCATION_HAND)
	c:RegisterEffect(ee)
	--유일이면 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(cyan.IsUnlockState)
	e1:SetCountLimit(1,103553000)
	cyan.JustSearch(e1,LOCATION_DECK,c103553000.thfilter,1)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--소생
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c103553000.spcost)
	e2:SetCountLimit(1,103553100)
	e2:SetCondition(c103553000.spcon)
	e2:SetTarget(c103553000.sptg)
	e2:SetOperation(c103553000.spop)
	c:RegisterEffect(e2)
end
function c103553000.unlocktg(e,tp,ep,eg,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(p,UNLOCK_COMPLETE)
		and not Duel.IsExistingMatchingCard(c103553000.chk,p,LOCATION_DECK+LOCATION_HAND,0,1,nil,p)
		and Duel.GetTurnCount()<4 end
end
function c103553000.chk(c,tp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,c:GetCode())
end
function c103553000.unlockop(e,tp,ep,eg,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(p,UNLOCK_COMPLETE) then return end
	if Duel.SelectYesNo(p,aux.Stringid(103553000,0)) then
		local nothing=Duel.SelectYesNo(1-p,aux.Stringid(103553000,1))
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(UNLOCK_COMPLETE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,p)
		local token=Duel.CreateToken(p,103553000)
		Duel.SendtoDeck(token,nil,2,REASON_EFFECT)
		local toke1n=Duel.CreateToken(p,103553000)
		Duel.SendtoDeck(toke1n,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
function c103553000.thfilter(c,ct)
	return aux.IsCodeListed(c,103553000)
end
function c103553000.thfilter2(c)
	return aux.IsCodeListed(c,103553000) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsPublic()
end
function c103553000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c103553000.thfilter2,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.ConfirmCards(1-tp,sg1)	
end
function c103553000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and not Duel.CheckPhaseActivity()	
end
function c103553000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c103553000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
