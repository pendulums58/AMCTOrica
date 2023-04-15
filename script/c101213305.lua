--시계탑의 유폐자
function c101213305.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x60a),1)
	c:EnableReviveLimit()
	--시계탑 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101213305)
	e1:SetCost(c101213305.thcost)
	e1:SetTarget(c101213305.thtg)
	e1:SetOperation(c101213305.thop)
	c:RegisterEffect(e1)
	--공격력 상승
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101213305.atktg)
	e2:SetValue(c101213305.atkval)
	c:RegisterEffect(e2)	
end
function c101213305.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabelObject(nil)
	if tc:IsCode(75041269) then
		e:SetLabelObject(tc)
	end
end
function c101213305.thfilter(c)
	return c:IsSetCard(0x60a) and c:IsAbleToHand()
end
function c101213305.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213305.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101213305.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101213305.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetLabelObject() and Duel.SelectYesNo(tp,aux.Stringid(101213305,0)) then
			Duel.MoveToField(e:GetLabelObject(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	end
end
function c101213305.atktg(e,c)
	return c:IsSetCard(0x60a)
end
function c101213305.atkval(e,c)
	return Duel.GetCounter(e:GetHandler():GetControler(),1,0,0x1b)*200
end
