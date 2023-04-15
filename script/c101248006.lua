--창성유물『신탁성궤』
c101248006.AccessMonsterAttribute=true
function c101248006.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101248006.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--묘지 회수
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101248006,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c101248006.thcon)
	e1:SetTarget(c101248006.thtg)
	e1:SetOperation(c101248006.thop)
	c:RegisterEffect(e1)
	--발동 제약
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c101248006.actcon)
	c:RegisterEffect(e2)	
end
function c101248006.afil1(c)
	return c:IsSetCard(0xfe) or c:IsSetCard(0x620)
end
function c101248006.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad and ad:IsSetCard(0x622)
end
function c101248006.filter1(c)
	return (c:GetLevel()==11 or c:IsSetCard(0xfe)) and c:IsAbleToHand()
end
function c101248006.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c101248006.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101248006.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101248006.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101248006.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101248006.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end