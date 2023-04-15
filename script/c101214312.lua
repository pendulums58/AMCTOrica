--스카이워커 메소스피어
function c101214312.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_THUNDER),aux.NonTuner(nil),1)
	c:EnableReviveLimit()	
	--프리체인 레벨 업
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101214312.lvtg)
	e1:SetOperation(c101214312.lvop)
	c:RegisterEffect(e1)
	--스카이워커 서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c101214312.con)
	e2:SetCountLimit(1,101214312)
	e2:SetTarget(c101214312.thtg)
	e2:SetOperation(c101214312.thop)
	c:RegisterEffect(e2)
end
function c101214312.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLevelAbove(1) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsLevelAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,1) end
	local tc=Duel.SelectTarget(tp,Card.IsLevelAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,1)
end
function c101214312.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)		
	end
end
function c101214312.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101214312.thfilter(c)
	return c:IsSetCard(0xef5) and c:IsLevelBelow(2) and c:IsAbleToHand()
end
function c101214312.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101214312.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101214312.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101214312.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0
		and not Duel.IsExistingMatchingCard(Card.IsLevelAbove,tp,LOCATION_MZONE,0,1,nil,12) then
		local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		end
	end
end