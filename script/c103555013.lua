--교류 벚꽃
function c103555013.initial_effect(c)
	--벚꽃 회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,103555013)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c103555013.thtg)
	e1:SetOperation(c103555013.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	cyan.AddSakuraEffect(c)
end
function c103555013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	local loc=LOCATION_GRAVE
	if g==1 then loc=loc+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c103555013.thfilter,tp,loc,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c103555013.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	local loc=LOCATION_GRAVE
	if (g==1 or Duel.IsPlayerAffectedByEffect(c:GetControler(),103555016)) then loc=loc+LOCATION_DECK end
	local g1=Duel.SelectMatchingCard(tp,c103555013.thfilter,tp,loc,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(g1,1-tp)
	end
end
function c103555013.thfilter(c)
	return c:IsSetCard(0x65a) and c:IsAbleToHand()
end