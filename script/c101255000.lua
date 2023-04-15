--환영검사 레반테라
function c101255000.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101255000,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101255000)
	e1:SetTarget(c101255000.target)
	e1:SetOperation(c101255000.operation)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--액세스 소재가 된 경우
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101255000,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c101255000.mkcon)
	e3:SetOperation(c101255000.mkop)
	c:RegisterEffect(e3)
end
function c101255000.filter(c)
	return c:IsSetCard(0x627) and not c:IsCode(101255000) and c:IsAbleToHand()
end
function c101255000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101255000.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101255000.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101255000.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101255000.mkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_ACCESS and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c101255000.mkop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.AnnounceCard(tp,0x627,OPCODE_ISSETCARD,TYPE_EQUIP,OPCODE_ISTYPE,OPCODE_AND)
	local token=Duel.CreateToken(tp,ac)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
end