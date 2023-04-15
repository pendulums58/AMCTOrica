--수면의 기사
function c101223018.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,aux.TRUE,c101223018.mfilter,2,2)
	c:EnableReviveLimit()
	--전투 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--드로우
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101223018,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(c101223018.drcon)
	e2:SetTarget(c101223018.drtg)
	e2:SetOperation(c101223018.drop)
	c:RegisterEffect(e2)
end
function c101223018.mfilter(c,pair)
	return c:IsRace(pair:GetRace())
end	
function c101223018.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_BATTLE)>0 and ep==tp
end
function c101223018.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101223018.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end