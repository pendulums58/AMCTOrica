--로스트메모리 - 에보니
function c101249008.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,3,c101249008.ovfilter,aux.Stringid(101249008,0))
	c:EnableReviveLimit()
	c:SetSPSummonOnce(101249008)
	--효과 제한
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101249008.cost)
	e1:SetTarget(c101249008.target)
	e1:SetOperation(c101249008.operation)
	c:RegisterEffect(e1)
	--파괴 제물
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c101249008.reptg)
	e2:SetOperation(c101249008.repop)
	c:RegisterEffect(e2)
end
function c101249008.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x623)
end
--효과 제한 관련
function c101249008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101249008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
function c101249008.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101249008.immfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE,0)
	if e:GetLabel()==0 then
		e1:SetDescription(aux.Stringid(101249008,2))
		e1:SetValue(c101249008.aclimit1)
		e1:SetLabel(aux.Stringid(101249008,2))
	elseif e:GetLabel()==1 then
		e1:SetDescription(aux.Stringid(101249008,3))
		e1:SetValue(c101249008.aclimit2)
		e1:SetLabel(aux.Stringid(101249008,3))
	else
		e1:SetDescription(aux.Stringid(101249008,4))
		e1:SetValue(c101249008.aclimit3)
		e1:SetLabel(aux.Stringid(101249008,4))
	end
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
end
function c101249008.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and e:GetOwnerPlayer()~=re:GetOwnerPlayer() 
end
function c101249008.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL) and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c101249008.aclimit3(e,re,tp)
	return re:IsActiveType(TYPE_TRAP) and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c101249008.immfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x623)
end
--파괴 제물 관련
function c101249008.repfilter(c,e)
	return (c:IsFaceup() and c:IsSetCard(0x623)) or c:IsCode(96765646)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c101249008.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c101249008.repfilter,tp,LOCATION_ONFIELD,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(101249008,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c101249008.repfilter,tp,LOCATION_ONFIELD,0,1,1,c,e)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c101249008.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end


