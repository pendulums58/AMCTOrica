--파이어폭스 익스플로러
c111310083.AccessMonsterAttribute=true
function c111310083.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,c111310083.afil1)
	c:EnableReviveLimit()
	--샐비지
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c111310083.tdcon)
	e1:SetTarget(c111310083.thtg)
	e1:SetOperation(c111310083.thop1)
	c:RegisterEffect(e1)
	--공격대상시 샐비지
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7198399,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetTarget(c111310083.thtg1)
	e2:SetOperation(c111310083.thop2)
	c:RegisterEffect(e2)	
end
function c111310083.afil1(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310083.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ACCESS
end
function c111310083.thfilter(c,ad)
	return c:IsRace(ad:GetRace()) and c:IsAbleToHand()
end
function c111310083.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ad=e:GetHandler():GetAdmin()
	if not ad then return false end
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c111310083.thfilter(c,ad) end
	if chk==0 then return Duel.IsExistingTarget(c111310083.thfilter,tp,LOCATION_GRAVE,0,1,nil,ad) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c111310083.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,ad)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c111310083.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c111310083.thfilter1(c,ad)
	return c:IsAttribute(ad:GetAttribute()) and c:IsAbleToHand()
end
function c111310083.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ad=e:GetHandler():GetAdmin()
	if not ad then return false end
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c111310083.thfilter1(c,ad) end
	if chk==0 then return Duel.IsExistingTarget(c111310083.thfilter1,tp,LOCATION_GRAVE,0,1,nil,ad) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c111310083.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil,ad)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c111310083.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end