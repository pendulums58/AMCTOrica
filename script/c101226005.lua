--신살마녀 메이틀립
c101226005.AccessMonsterAttribute=true
function c101226005.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101226005.afil1,c101226005.afil2)
	c:EnableReviveLimit()
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101226005)
	e1:SetCondition(c101226005.con)
	e1:SetTarget(c101226005.thtg)
	e1:SetOperation(c101226005.thop)
	c:RegisterEffect(e1)
	--묘지의 신살마녀 특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101226005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101226105)
	e2:SetCondition(c101226005.condition2)
	e2:SetTarget(c101226005.target2)
	e2:SetOperation(c101226005.operation2)
	c:RegisterEffect(e2)	
end
function c101226005.afil1(c)
	return c:GetAttack()<=2000
end
function c101226005.afil2(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c101226005.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ACCESS
end
function c101226005.thfilter(c)
	return c:IsSetCard(0x612) and c:IsAbleToGrave()
end
function c101226005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101226005.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101226005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101226005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101226005.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	if not ad then return false end
	return rp==tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttack()>ad:GetAttack()
end
function c101226005.filter(c,e,tp)
	return c:IsSetCard(0x612) and not c:IsType(TYPE_ACCESS) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101226005.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101226005.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101226005.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101226005.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101226005.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
