--유니에이트 리전트리퍼
function c101266011.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101266011.pfilter,c101266011.mfilter,2,2)
	c:EnableReviveLimit()
	--페어 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_PAIR)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(c101266011.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--강탈효과 본체
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SELECTBY_OPPO)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--서치한거 강탈
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCountLimit(1)
	e3:SetCost(c101266011.cost)
	e3:SetCondition(c101266011.condition)
	e3:SetTarget(c101266011.target)
	e3:SetOperation(c101266011.activate)
	c:RegisterEffect(e3)
end
function c101266011.pfilter(c)
	return c:IsSetCard(0x634) and c:IsType(TYPE_PAIRING)
end
function c101266011.mfilter(c,pair)
	return c:GetLevel()<pair:GetLevel()
end
function c101266011.indcon(e)
	local c=e:GetHandler()
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
end
function c101266011.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c101266011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101266011.costfilter,1,nil,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c101266011.costfilter,1,1,nil,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c101266011.costfilter(c,pair)
	return c:GetPair():IsContains(pair)
end
function c101266011.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101266011.cfilter,1,nil,1-tp)
end
function c101266011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c101266011.cfilter,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101266011.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
