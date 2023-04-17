--소원 어센더
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(cyan.selfdiscost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.filter(c,e,tp)
	return c:IsRelateToEffect(e) and s.cfilter(c,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.filter,nil,e,1-tp)
	if #dg>0 then
		Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
