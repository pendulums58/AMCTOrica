--스토리텔러-단풍의 작가
function c103550002.initial_effect(c)
	--자신 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,103550002)
	e1:SetCondition(c103550002.spcon)
	e1:SetTarget(c103550002.sptg)
	e1:SetOperation(c103550002.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--지속 마법 구현화
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cyan.selfrelcost)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c103550002.mtg)
	e3:SetOperation(c103550002.mop)
	c:RegisterEffect(e3)
	--서치
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,103550102)
	e4:SetCost(c103550002.thcost)
	cyan.JustSearch(e4,LOCATION_DECK,Card.IsCode,103550003)
	c:RegisterEffect(e4)
end
function c103550002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c103550002.tchk,1,nil)
end
function c103550002.tchk(c)
	return c:GetOriginalType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c103550002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end
function c103550002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c103550002.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and c103550002.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c103550002.filter,tp,LOCATION_SZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,e:GetHandler())>0 end
	local g=Duel.SelectTarget(tp,c103550002.filter,tp,LOCATION_SZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),tp,LOCATION_SZONE)
end
function c103550002.mop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		tc:AddStoryTellerAttribute(e:GetHandler())
		Duel.SpecialSummonComplete()		
	end
end
function c103550002.filter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),Duel.ReadCard(c,CARDDATA_SETCODE),TYPES_NORMAL_TUNER_MONSTER,500,500,3,RACE_FAIRY,ATTRIBUTE_LIGHT)
end
function c103550002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c103550002.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c103550002.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c103550002.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x64a)
		and c:IsAbleToRemoveAsCost()
end