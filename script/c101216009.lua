--성설의 이중주
function c101216009.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--성설 잠금해제
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(89181369)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--제외되면 1드로
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101216009,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,101216009)
	e3:SetCondition(c101216009.tgcon)
	e3:SetTarget(c101216009.drtg)
	e3:SetOperation(c101216009.drop)
	c:RegisterEffect(e3)
end
function c101216009.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==2 and not eg:IsExists(c101216009.drfilter,1,nil)
end
function c101216009.drfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsControler(1-tp) or not c:IsPreviousLocation(LOCATION_GRAVE)
end
function c101216009.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101216009.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end