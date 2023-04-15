--하나게키 #이스트 스타일
function c101254002.initial_effect(c)
	--마법 / 함정 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c101254002.target)
	e1:SetCountLimit(1,101254002)
	e1:SetOperation(c101254002.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--상대 덱 검열
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101254002)
	e2:SetCondition(c101254002.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101254002.distg)
	e2:SetOperation(c101254002.disop)
	c:RegisterEffect(e2)	
end
function c101254002.filter(c)
	return c:IsSetCard(0x626) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c101254002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101254002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101254002.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101254002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101254002.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c101254002.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c101254002.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local rm=Duel.SelectMatchingCard(1-tp,c101254002.rmfilter,tp,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,1,1,nil,tc:GetCode())
	if rm:GetCount()>0 then
		Duel.Remove(rm,POS_FACEUP,REASON_EFFECT)
	end
end
function c101254002.rmfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemove()
end