--이치를 받아들이는 니르바나
function c101242010.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101242010.target)
	e1:SetOperation(c101242010.activate)
	c:RegisterEffect(e1)
	--드로우
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101242010.con)
	e2:SetCountLimit(1,101242010)
	e2:SetCost(aux.bfgcost)
	cyan.JustDraw(e2,2)
	c:RegisterEffect(e2)
end
function c101242010.filter(c)
	return (c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and c:IsSetCard(0x61c) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c101242010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101242010.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c101242010.filter1(c,e,tp)
	return c:IsSetCard(0x61c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end
function c101242010.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101242010.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101242010.filter1,tp,LOCATION_HAND,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(101242010,0)) then
				local g=Duel.SelectMatchingCard(tp,c101242010.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
				end
		end
	end
end
function c101242010.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101242010.nfilter,1,nil) and ep==tp
end
function c101242010.nfilter(c)
	return c:IsCode(80896940)
end