--EXE 프로듀서
c111310086.AccessMonsterAttribute=true
function c111310086.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()
	--데미지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c111310086.nscon)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c111310086.disop)
	c:RegisterEffect(e1)
	--마함 파괴
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111310086,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c111310086.target)
	e3:SetOperation(c111310086.operation)
	c:RegisterEffect(e3)	
end
function c111310086.nscon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad and (ad:IsSetCard(0x606) or ad:IsAttribute(ATTRIBUTE_FIRE)) 
		and eg:IsExists(c111310086.deschk,1,nil,tp)
end
function c111310086.deschk(c,tp)
	return c:IsControler(1-tp) and (c:GetLevel()>0 or c:GetRank()>0)
end
function c111310086.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c111310086.deschk,nil,tp)
	local dam=g:GetSum(Card.GetLevel,nil)
	dam=dam+g:GetSum(Card.GetRank,nil)
	dam=dam*300
	Duel.Damage(1-tp,dam,REASON_EFFECT)	
end
function c111310086.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c111310086.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end