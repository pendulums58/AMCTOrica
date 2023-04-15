--에고파인더 어웨이큰
c101217021.AccessMonsterAttribute=true
function c101217021.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101217021.afil1,c101217021.afil2)
	c:EnableReviveLimit()
	
	--액세스 소환 성공시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101217021.spcon)
	e1:SetTarget(c101217021.target)
	e1:SetOperation(c101217021.op)
	c:RegisterEffect(e1)
	
	--필드의 카드 1장 파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101217021.descost)
	e2:SetTarget(c101217021.destg)
	e2:SetOperation(c101217021.desop)
	c:RegisterEffect(e2)
end
function c101217021.afil1(c)
   return c:IsCode(101217000)
end
function c101217021.afil2(c)
   return c:IsType(TYPE_XYZ)
end
function c101217021.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c101217021.cfilter(c,e,tp,cod)
	return c:IsCode(cod) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101217021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101217021.cfilter(chkc,e,tp,cod) end
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if not ad then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101217021.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ad:GetCode()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101217021.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ad:GetCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101217021.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101217021.thfilter(c)
	return c:IsSetCard(0xef7) and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c101217021.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101217021.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101217021.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101217021.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101217021.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end