--아련 벚꽃
function c103555011.initial_effect(c)
	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x65a),2,2)
	c:EnableReviveLimit()
	--벚꽃 해금
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCondition(cyan.LinkSSCon)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)	
	e1:SetOperation(c103555011.sdop)
	c:RegisterEffect(e1)
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cyan.selfrelcost)
	cyan.JustSearch(e2,LOCATION_DECK,Card.IsSetCard,0x65a)
	c:RegisterEffect(e2)
	cyan.AddSakuraEffect(c)
end
function c103555011.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(103555011)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end