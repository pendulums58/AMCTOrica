--눈꽃의 소원
local s,id=GetID()
function s.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,aux.TRUE,s.mfilter,2,2)
	c:EnableReviveLimit()
	--자체 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,id)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	
	--묘지 덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cyan.selfrmcost)
	e2:SetCondition(aux.exccon)
	cyan.JustDump(e2,1,1,LOCATION_DECK,Card.IsType,TYPE_MONSTER)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,function(re) return not (re:IsMonsterEffect() and re:GetActivateLocation()==LOCATION_HAND) end)
end
function s.mfilter(c,pair)
	return c:GetLevel()<pair:GetLevel() and c:GetLevel()>0
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
