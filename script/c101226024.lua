--신살마녀의 직시
function c101226024.initial_effect(c)
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101226024)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c101226024.cost)
	e1:SetTarget(c101226024.target)
	e1:SetOperation(c101226024.activate)
	c:RegisterEffect(e1)	
	--소환 반응
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCost(c101226024.tgcost)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101226124)
	e2:SetTarget(c101226024.tgtg)
	e2:SetOperation(c101226024.tgop)
	c:RegisterEffect(e2)
end
function c101226024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101226024.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c101226024.costfilter(c,ec,tp)
	if not (c:IsSetCard(0x612)) then return false end
	return Duel.IsExistingTarget(c101226024.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c,c,ec)
end
function c101226024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c101226024.costfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	g:Merge(g1)
	local tc=g1:GetFirst()
	while tc do
		local ad=tc:GetAdmin()
		if ad and ad:IsAbleToGraveAsCost() then g:AddCard(ad) end
		tc=g1:GetNext()
	end
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return g:GetCount()>0
		else
			return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c101226024.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c101226024.filter(c,e,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and (not e or c:IsRelateToEffect(e))
		and not Duel.IsExistingMatchingCard(c101226024.atkchk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c101226024.atkchk(c,atk)
	return c:GetAttack()>atk
end
function c101226024.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil)
		and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101226024.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101226024.filter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c101226024.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101226024.filter,nil,e,tp)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
