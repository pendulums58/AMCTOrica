--유니에이트 커멘토
function c101266009.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101266009.pfilter,c101266009.mfilter,1,1)
	c:EnableReviveLimit()	
	--소환시 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c101266009.thcon)
	e1:SetTarget(c101266009.thtg)
	e1:SetOperation(c101266009.thop)
	c:RegisterEffect(e1)
	--대상 제한
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c101266009.atlimit)
	c:RegisterEffect(e2)
	--드로우
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101266009,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c101266009.spcon)
	cyan.JustDraw(e3,1)
	c:RegisterEffect(e3)
end
function c101266009.pfilter(c)
	return c:IsSetCard(0x634) and c:GetPairCount()==0
end
function c101266009.mfilter(c,pair)
	if (pair:GetLevel()<=0 or c:GetLevel()<=0) then return false end
	return c:GetLevel()~=pair:GetLevel()
end
function c101266009.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PAIRING)
end
function c101266009.filter(c,ad)
	return ad:IsExists(Card.IsCode,1,nil,c:GetCode()) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c101266009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ad=e:GetHandler():GetPair()
	if chk==0 then return ad and Duel.IsExistingMatchingCard(c101266009.filter,tp,LOCATION_DECK,0,1,nil,ad) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101266009.thop(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetPair()
	if ad==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101266009.filter,tp,LOCATION_DECK,0,1,1,nil,ad)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101266009.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0x634)
end
function c101266009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_PAIR)
end
