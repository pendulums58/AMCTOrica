--니르바나 스페이스킹
function c101242004.initial_effect(c)
	--펜듈럼 속성
	aux.EnablePendulumAttribute(c)
	--파괴 내성 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101242004.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--먹고 특소
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,101242004)
	e3:SetCondition(c101242004.spcon)
	e3:SetOperation(c101242004.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e4)
	--파괴하고 서치
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,101242104)
	e5:SetTarget(c101242004.thtg)
	e5:SetOperation(c101242004.thop)
	c:RegisterEffect(e5)
end
function c101242004.indtg(e,c)
	return c:IsSetCard(0x61c)
end
function c101242004.spfilter(c,ft,tp,sp)
	return c:IsSetCard(0x61c)
		and ((ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) or sp:IsLocation(LOCATION_EXTRA)) and (c:IsControler(tp) or c:IsFaceup())
end
function c101242004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c101242004.spfilter,1,nil,ft,tp,c)
end
function c101242004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c101242004.spfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c101242004.thfilter(c)
	return Duel.IsExistingMatchingCard(c101242004.thfilter1,tp,LOCATION_PZONE,0,1,nil,c:GetCode())
end
function c101242004.thfilter1(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c101242004.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) end
	if chk==0 then return Duel.IsExistingTarget(c101242004.thfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101242004.thfilter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101242004.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101242004.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tc:GetOriginalCode())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end		
	end
end