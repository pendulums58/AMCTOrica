--라스트 오스
function c101223044.initial_effect(c)
	c:SetUniqueOnField(1,0,101223044)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--펌핑
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c101223044.val)
	c:RegisterEffect(e1)
	--드로우
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101223044,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c101223044.drcon)
	e2:SetTarget(c101223044.drtg)
	e2:SetOperation(c101223044.drop)
	c:RegisterEffect(e2)	
end
function c101223044.val(e,c)
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c101223044.pchk,tp,LOCATION_MZONE,0,nil)*500
end
function c101223044.pchk(c)
	return c:GetPairCount()>0
end
function c101223044.cfilter(c,tp)
	return c:IsReason(REASON_PAIR) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c101223044.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223044.cfilter,1,nil,tp)
end
function c101223044.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101223044.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
