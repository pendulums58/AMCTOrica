--조 여환무장【골드블로섬】
function c101234022.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101234022.pfilter1,c101234022.pfilter2,1,1)
	c:EnableReviveLimit()
	--제외
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCost(c101234022.remcost)
	e1:SetCountLimit(1,101234022)
	e1:SetTarget(c101234022.remtg)
	e1:SetOperation(c101234022.remop)
	c:RegisterEffect(e1)
end
function c101234022.pfilter1(c)
	return c:IsSetCard(0x611) 
end
function c101234022.pfilter2(c)
	return c:IsSetCard(0x611) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c101234022.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local pg=e:GetHandler():GetPair()
	local pgc=pg:GetFirst()
	local ct=0
	while pgc do
		if pgc:GetAttackAnnouncedCount()~=0 then ct=1 end
		pgc=pg:GetNext()
	end
	if chk==0 then return ct==0 end
	pgc=pg:GetFirst()
	while pgc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		pgc:RegisterEffect(e1)
		pgc=pg:GetNext()
	end
end
function c101234022.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c101234022.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end