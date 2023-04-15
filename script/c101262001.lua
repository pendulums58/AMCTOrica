--뇌명으로 벼린 다리
function c101262001.initial_effect(c)
	--발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--뇌명 잠금해제
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(101262001)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--덱특소
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,101262001)
	e2:SetCondition(c101262001.spcon)
	e2:SetTarget(c101262001.sptg)
	e2:SetOperation(c101262001.spop)
	c:RegisterEffect(e2)
	--뇌명 발동시 해금
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c101262001.con)
	e3:SetTarget(c101262001.target)
	e3:SetOperation(c101262001.activate)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101262001,ACTIVITY_CHAIN,c101262001.chainfilter)
end
function c101262001.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(56260110)
end
function c101262001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c101262001.filter(c,e,tp)
	return c:IsSetCard(0x62d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101262001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101262001.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101262001.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101262001.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101262001.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101262001,tp,ACTIVITY_CHAIN)~=0
end
function c101262001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101262001.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end