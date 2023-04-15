--신살마녀 에델류지
c101226006.AccessMonsterAttribute=true
function c101226006.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101226006.afil1,c101226006.afil2)
	c:EnableReviveLimit()
	--액세스 성공시 바운스
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c101226006.thcon)
	e1:SetTarget(c101226006.thtg)
	e1:SetOperation(c101226006.thop)
	c:RegisterEffect(e1)
	--내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x612))
	e2:SetValue(c101226006.efilter)
	c:RegisterEffect(e2)	
end
function c101226006.afil1(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c101226006.afil2(c)
	return c:IsSetCard(0x612)
end
function c101226006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c101226006.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101226006.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101226006.efilter(e,te)
	local ad=e:GetHandler():GetAdmin()
	if not ad then return false end
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():GetAttack()>ad:GetAttack()
end