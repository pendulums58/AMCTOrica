--월하일섬
function c101271010.initial_effect(c)
	--효과 발동시 1장 서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101271010,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101271010)
	e1:SetTarget(c101271010.mvtg)
	e1:SetOperation(c101271010.mvop)
	c:RegisterEffect(e1)
	--메인 몬스터 이동 시 이 카드를 묘지에서 패로
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101271110)
	e2:SetCondition(c101271010.thcon)
	e2:SetTarget(c101271010.thtg)
	e2:SetOperation(c101271010.thop)
	c:RegisterEffect(e2)
end
--1번 효과 구현
function c101271010.mvfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x642) and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(c101271010.mvfilter3,tp,LOCATION_MZONE,0,1,c)
end
function c101271010.mvfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0x642) and c:GetSequence()<5
end
function c101271010.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b2=Duel.IsExistingMatchingCard(c101271010.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return b2 end
end
function c101271010.mvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g1=Duel.SelectMatchingCard(tp,c101271010.mvfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local tc1=g1:GetFirst()
		if not tc1 then return end
		Duel.HintSelection(g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g2=Duel.SelectMatchingCard(tp,c101271010.mvfilter3,tp,LOCATION_MZONE,0,1,1,tc1)
		Duel.HintSelection(g2)
		local tc2=g2:GetFirst()
		Duel.SwapSequence(tc1,tc2)
end
--2번 효과 구현
function c101271010.thcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function c101271010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c101271010.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end