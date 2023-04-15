--묻힌 세계의 익스플로러
c101270002.AmassEffect=1
function c101270002.initial_effect(c)
	--축적
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101270002)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c101270002.amtg)
	e1:SetOperation(c101270002.amop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--제외시
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c101270002.destg)
	e3:SetCountLimit(1,101270102)
	e3:SetOperation(c101270002.desop)
	c:RegisterEffect(e3)
end
function c101270002.amtg(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return Duel.AmassCheck(tp) end
end
function c101270002.amop(e,tp,ep,eg,ev,re,r,rp)
	Duel.Amass(e,500)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local val=g:GetSum(Card.GetAttack,nil)
	if val>=3000 and Duel.IsExistingMatchingCard(c101270002.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101270002,0)) then
		local tc=Duel.SelectMatchingCard(tp,c101270002.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if tc:GetCount()>0 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function c101270002.tgfilter(c)
	return c.AmassEffect and c:IsAbleToGrave()
end
function c101270002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101270002.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,POS_FACEUP,REASON_EFFECT)
	end
end