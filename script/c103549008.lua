--마칭 파이어 라스트 리조트
function c103549008.initial_effect(c)
	--code
	aux.EnableChangeCode(c,82705573,LOCATION_SZONE+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy+counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103549008,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,103549008)
	e2:SetTarget(c103549008.target)
	e2:SetOperation(c103549008.operation)
	c:RegisterEffect(e2)
	--destroy counter added something
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103549008,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,103549908)
	e3:SetCondition(c103549008.descon)
	e3:SetTarget(c103549008.destg)
	e3:SetOperation(c103549008.desop)
	c:RegisterEffect(e3)
end
c103549008.counter_add_list={0x1325}
function c103549008.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c103549008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103549008.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c103549008.cofilter(c)
	return c:IsFaceup() and c:IsCode(82705573)
end
function c103549008.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c103549008.cofilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c103549008.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local t=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil,0x1019,1)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		for i=1,ct do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local tc=t:Select(tp,1,1,nil):GetFirst()
			tc:AddCounter(0x1325,1)
		end
	end
end
function c103549008.cfilter(c,tp)
	return (c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function c103549008.dfilter(c)
	return c:GetCounter(0x1325)>0
end
function c103549008.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c103549008.cfilter,1,nil,tp)
end
function c103549008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c103549008.dfilter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c103549008.dfilter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c103549008.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then 
		Duel.Destroy(tc,REASON_EFFECT)
		if tc:IsType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_FIRE) then
			if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(1)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
		end
	end
end
