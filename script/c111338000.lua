--R-PINE 바인더
function c111338000.initial_effect(c)
	--미어식 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111338000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,111338000)
	e1:SetCondition(c111338000.spcon)
	e1:SetCost(c111338000.spcost1)
	e1:SetTarget(c111338000.sptg1)
	e1:SetOperation(c111338000.spop1)
	c:RegisterEffect(e1)
	--상대 턴에 싱크로 몬스터가...
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111338000,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)	
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,111338500)
	e2:SetCondition(c111338000.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c111338000.thtg)
	e2:SetOperation(c111338000.thop)	
	c:RegisterEffect(e2)
end
--미어 특소
function c111338000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not (r==REASON_RULE)
end
function c111338000.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c111338000.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c111338000.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--릴리스시
function c111338000.cfilter(c,tp)
	local ty=c:GetPreviousTypeOnField()
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and bit.band(ty,TYPE_SYNCHRO)==TYPE_SYNCHRO
end
function c111338000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp 
	and eg:IsExists(c111338000.cfilter,1,nil,tp)
end
function c111338000.thfilter(c)
	return c:IsSetCard(0x656) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsType(TYPE_TUNER) 
end
function c111338000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111338000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111338000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111338000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end