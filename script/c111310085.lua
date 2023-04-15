--PNG 코디네이터
c111310085.AccessMonsterAttribute=true
function c111310085.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()
	--1턴에 1번 무효 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c111310085.nscon)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c111310085.disop)
	c:RegisterEffect(e1)
	--제외
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310085,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c111310085.target)
	e2:SetOperation(c111310085.operation)
	c:RegisterEffect(e2)	
end
function c111310085.nscon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return ad and (ad:IsSetCard(0x606) or ad:IsAttribute(ATTRIBUTE_WATER))
		and g and g:IsExists(c111310085.negchk,1,nil,tp) and re:GetHandler():IsControler(1-tp)
end
function c111310085.negchk(c,tp)
	return c:GetFlagEffect(111310085)==0 and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c111310085.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	g=g:Filter(Card.IsControler,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(111310085,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
end
function c111310085.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and c111310085.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c111310085.rmfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c111310085.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c111310085.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c111310085.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end