--환영검성 에위니아
c101255005.AccessMonsterAttribute=true
function c101255005.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101255005.afil1,c101255005.afil2)
	c:EnableReviveLimit()
	--소환시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101255005)
	e1:SetCondition(c101255005.tdcon)
	e1:SetTarget(c101255005.thtg)
	e1:SetOperation(c101255005.thop1)
	c:RegisterEffect(e1)	
	--파 괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101255005.drcon)
	e2:SetTarget(c101255005.drtg)
	e2:SetOperation(c101255005.drop)
	c:RegisterEffect(e2)	
end
function c101255005.afil1(c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipCount()>0
end
function c101255005.afil2(c)
	return c:IsRace(RACE_WARRIOR)
end
function c101255005.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c101255005.thfilter(c)
	return c:IsSetCard(0x627) and c:IsAbleToHand()
end
function c101255005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101255005.thfilter(c) end
	if chk==0 then return Duel.IsExistingTarget(c101255005.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101255005.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101255005.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101255005.drfilter(c,tp,tc)
	return c:IsSetCard(0x627) and c:GetEquipTarget()==tc and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,c,c:GetCode())
end
function c101255005.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101255005.drfilter,1,nil,tp,e:GetHandler())
end
function c101255005.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101255005.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,POS_FACEUP,REASON_EFFECT)
	end
end