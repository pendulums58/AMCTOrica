--DLL 오울
c111310072.AccessMonsterAttribute=true
function c111310072.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()
	--동명 서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310072,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310072.thcon)
	e1:SetTarget(c111310072.thtg)
	e1:SetOperation(c111310072.thop)
	c:RegisterEffect(e1)
	--동명 효과 발동 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c111310072.aclimit)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--비행야수족 서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c111310072.thcon1)
	e3:SetTarget(c111310072.thtg1)
	e3:SetOperation(c111310072.thop1)
	c:RegisterEffect(e3)
end
function c111310072.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310072.filter(c,ad)
	return c:IsCode(ad:GetCode()) and c:IsAbleToHand()
end
function c111310072.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ad=e:GetHandler():GetAdmin()
	if chk==0 then return ad and Duel.IsExistingMatchingCard(c111310072.filter,tp,LOCATION_DECK,0,1,nil,ad) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111310072.thop(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	if ad==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111310072.filter,tp,LOCATION_DECK,0,1,1,nil,ad)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c111310072.aclimit(e,re,tp)
	local ad=e:GetHandler():GetAdmin()
	local c=re:GetHandler()
	return ad and re:IsActiveType(TYPE_MONSTER) and c:IsCode(ad:GetCode())
end
function c111310072.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c111310072.thfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAbleToHand()
end
function c111310072.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310072.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111310072.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111310072.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
