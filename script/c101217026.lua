--에고파인더 언:컨셔스
c101217026.AccessMonsterAttribute=true
function c101217026.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101217026.afil1,c101217026.afil2)
	c:EnableReviveLimit()
	--소환시 파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c101217026.thcon)
	e1:SetTarget(c101217026.thtg)
	e1:SetOperation(c101217026.thop)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c101217026.rcost)
	e2:SetTarget(c101217026.rtg)
	e2:SetOperation(c101217026.rop)
	c:RegisterEffect(e2)
end
function c101217026.afil1(c)
   return c:IsCode(101217000)
end
function c101217026.afil2(c)
   return c:IsOriginalCodeRule(101217001)
end
function c101217026.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c101217026.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetHandler():GetAdmin()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e:GetHandler():GetAdmin())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c101217026.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c101217026.spfilter(c,ad)
	return c:IsCode(ad) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c101217026.rcost(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	if chk==0 then return ad~=nil and Duel.IsExistingMatchingCard(c101217026.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,ad)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c101217026.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,ad)
	if g:GetCount()>0 then
		Duel.SendToGrave(g,REASON_EFFECT)
	end
end
function c101217026.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c101217026.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end