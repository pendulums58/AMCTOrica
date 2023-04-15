--종언을 외치는 시계
function c101213327.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101213327.rmtg)
	e1:SetOperation(c101213327.rmop)
	c:RegisterEffect(e1)
	--해피 or 번개
	local e2=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c101213327.descon)
	e2:SetTarget(c101213327.destg)
	e2:SetOperation(c101213327.desop)
	c:RegisterEffect(e2)
end
function c101213327.cfilter(c,type)
	return c:IsSetCard(0x60a) and c:IsType(type)
end
function c101213327.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=0
	for i,type in ipairs({TYPE_FUSION,TYPE_ACCESS,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK,TYPE_PAIRING}) do
		if Duel.IsExistingMatchingCard(c101213327.cfilter,tp,LOCATION_MZONE,0,1,nil,type) then
			ct=ct+1
		end
	end
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101213327.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	for i,type in ipairs({TYPE_FUSION,TYPE_ACCESS,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK,TYPE_PAIRING}) do
		if Duel.IsExistingMatchingCard(c101213327.cfilter,tp,LOCATION_MZONE,0,1,nil,type) then
			ct=ct+1
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c101213327.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101213327.descheck,tp,LOCATION_MZONE,0,1,nil)
end
function c101213327.descheck(c)
	return c:IsType(TYPE_ACCESS) and c:IsSetCard(0x60a) and c:GetAdmin()==nil
end
function c101213327.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0):GetCount()>0
	local b2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)>0
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(101213327,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(101213327,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(101213327,0),aux.Stringid(101213327,1))
	end
	e:SetLabel(s)
	local g=nil
	if s==0 then
		g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	end
	if s==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101213327.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	if e:GetLabel()==0 then
		g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	end
	if e:GetLabel()==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e),TYPE_SPELL+TYPE_TRAP)
	end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end