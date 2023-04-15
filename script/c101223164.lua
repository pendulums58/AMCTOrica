--유물을 깨우는 신령
function c101223164.initial_effect(c)
	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--몬스터 존 제한
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e1:SetValue(c101223164.frcval)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101223164.descon)
	e2:SetTarget(c101223164.destg)
	e2:SetOperation(c101223164.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c101223164.descon1)
	c:RegisterEffect(e3)
end
function c101223164.frcval(e,c,fp,rp,r)
	local tp=0
	local g=Duel.GetMatchingGroup(c101223164.lchk,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local zone=0
	local tc=g:GetFirst()
	while tc do
		zone=bit.bor(zone,tc:GetLinkedZone())
		tc=g:GetNext()
	end
	zone=bit.bor(zone,0x60)
	return zone | 0x600060
end
function c101223164.lchk(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c101223164.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223164.deschk,1,nil,tp)
end
function c101223164.deschk(c,tp)
	return c:IsPreviousControler(1-tp) and c:GetSummonLocation()==LOCATION_GRAVE
end
function c101223164.descon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223164.deschk1,1,nil)
end
function c101223164.deschk1(c)
	return c:IsPreviousLocation(LOCATION_GRAVE)
end
function c101223164.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	if e:GetHandler():GetMutualLinkedGroupCount()>0 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
	elseif e:GetHandler():IsExtraLinkState() then
		e:SetCategory(0)
		e:SetLabel(2)
	else
		e:SetCategory(CATEGORY_DESTROY)
		e:SetLabel(0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	end
end
function c101223164.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if e:GetLabel()==0 then
		Duel.Destroy(g,REASON_EFFECT)
	elseif e:GetLabel()==1 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	elseif e:GetLabel()==2 then
		Duel.Exile(g,REASON_EFFECT)
	else
	
	end
end