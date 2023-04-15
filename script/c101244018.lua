--패러리얼 스페이스보틀
function c101244018.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,c101244018.twfilter,c101244018.twfilter1,1,true,true)
	--뒷면카드 파괴
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101244018,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101244018.descon)
	e1:SetTarget(c101244018.destg)
	e1:SetOperation(c101244018.desop)
	c:RegisterEffect(e1)
	--패러리얼 서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101244018,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c101244018.con)
	e2:SetTarget(c101244018.thtg2)
	e2:SetOperation(c101244018.thop2)
	c:RegisterEffect(e2)
end
function c101244018.twfilter(c,fc)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown()
end
function c101244018.twfilter1(c)
	return c:IsSetCard(0x61e) and c:IsType(TYPE_MONSTER)
end
function c101244018.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101244018.filter(c)
	return c:IsFacedown()
end
function c101244018.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101244018.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101244018.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101244018.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101244018.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c101244018.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101244018.thfilter2(c)
	return c:IsSetCard(0x61e)and c:IsAbleToHand()
end
function c101244018.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101244018.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101244018.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101244018.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end