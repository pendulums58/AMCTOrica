--진원기록『관리자』
function c101246000.initial_effect(c)
	--융합 소재시
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101246000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101246000)
	e1:SetCondition(c101246000.condition)
	e1:SetTarget(c101246000.sptg)
	e1:SetOperation(c101246000.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_HAND)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101246000,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101246100)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101246000.drcon)
	e3:SetTarget(c101246000.drtg)
	e3:SetOperation(c101246000.drop)
	c:RegisterEffect(e3)
	--파괴 효과
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101246000,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c101246000.descost)
	e4:SetTarget(c101246000.destg)
	e4:SetOperation(c101246000.desop)
	c:RegisterEffect(e4)
end
function c101246000.cfilter(c,tp)
	local mat=c:GetMaterial()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsType(TYPE_FUSION) and mat and mat:IsExists(Card.IsControler,1,nil,1-tp)
end
function c101246000.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101246000.cfilter,1,nil,tp)
end
function c101246000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101246000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c101246000.thchk(c,tp)
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c101246000.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101246000.thchk,1,nil,tp)
end
function c101246000.thfilter(c)
	return (c:IsSetCard(0x620) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0x61e) and c:IsAbleToHand()
end
function c101246000.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101246000.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101246000.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101246000.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101246000.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101246000.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	local mc=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,TYPE_FUSION)
	if chk==0 then return mc>0 and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,mc,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101246000.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
