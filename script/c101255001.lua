--환영검사 선다우너
function c101255001.initial_effect(c)
	--생성
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101255001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101255001)
	e1:SetOperation(c101255001.mkop)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	--묘지에서 회수
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101255100)
	e3:SetCost(c101255001.thcost)
	e3:SetTarget(c101255001.thtg)
	e3:SetOperation(c101255001.thop)
	c:RegisterEffect(e3)
end
function c101255001.mkop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.AnnounceCard(tp,0x627,OPCODE_ISSETCARD,TYPE_EQUIP,OPCODE_ISTYPE,OPCODE_AND)
	local token=Duel.CreateToken(tp,ac)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
end
function c101255001.cfilter(c)
	return c:IsSetCard(0x627) and c:IsDiscardable()
end
function c101255001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101255001.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101255001.cfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c101255001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101255001.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
