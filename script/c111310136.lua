--PM(프로토콜 마스터).19 시리얼 트래커
function c111310136.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()	
	--말살
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cyan.AccSSCon)
	e1:SetTarget(c111310136.destg)
	e1:SetOperation(c111310136.desop)
	c:RegisterEffect(e1)
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c111310136.condition)
	e2:SetTarget(c111310136.target)
	e2:SetOperation(c111310136.operation)
	c:RegisterEffect(e2)	
end
function c111310136.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310136.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c111310136.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),tp,LOCATION_ONFIELD)
end
function c111310136.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c111310136.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c111310136.desfilter(c)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(Card.IsCode,0,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c:GetCode())
end
function c111310136.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c111310136.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ad=e:GetHandler():GetAdmin()
	if chkc then return ad and chkc:IsLocation(LOCATION_GRAVE)
		and chkc:IsControler(tp) and c111310136.spfilter(chkc,e,tp,ad) end
	if chk==0 then return ad and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c111310136.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ad) end
	local tc=Duel.SelectTarget(tp,c111310136.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ad)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function c111310136.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c111310136.spfilter(c,e,tp,ad)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(ad:GetCode())
end