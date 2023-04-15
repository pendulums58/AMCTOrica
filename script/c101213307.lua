--시계탑의 수호병기
function c101213307.initial_effect(c)
	--링크 소환
	aux.AddLinkProcedure(c,nil,2,2,c101213307.lcheck)
	c:EnableReviveLimit()
	--카운터를 쌓는다
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101213307,2))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c101213307.negop)
	c:RegisterEffect(e1)
	--전투 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCondition(c101213307.indcon)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--필드의 카드 파괴
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101213307,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c101213307.descost)
	e3:SetTarget(c101213307.destg)
	e3:SetOperation(c101213307.desop)
	c:RegisterEffect(e3)	
end
function c101213307.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x60a)
end
function c101213307.negop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local ctl=lg:Filter(Card.IsControler,nil,tp)
	ctl=ctl:GetFirst()
	if not ctl then return end
	local opl=lg:Filter(Card.IsControler,nil,1-tp)
	local mylv=ctl:GetLevel()
	if ctl:IsType(TYPE_XYZ) then mylv=ctl:GetRank() end
	opl=opl:GetFirst()
	local oplv=0
	if opl then
		oplv=opl:GetLevel()
		if opl:IsType(TYPE_XYZ) then oplv=opl:GetRank() end
	end
	local ct=mylv-oplv
	if ct<=0 then return end
	
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_FZONE,0,1,1,nil,75041269)
	if g:GetCount()>0 then
		tc=g:GetFirst()
		tc:AddCounter(0x1b,ct)
	end
end
function c101213307.indcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c101213307.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101213307.cfilter(c)
	return c:IsFaceup() and c:IsCode(75041269)
end
function c101213307.spcfilter(c,tp)
	return c:IsCode(75041269) and c:IsCanRemoveCounter(tp,0x1b,2,REASON_COST)
end
function c101213307.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101213307.spcfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local tc=g:GetFirst()
	if chk==0 then return tc end
	tc:RemoveCounter(tp,0x1b,2,REASON_COST)
end
function c101213307.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101213307.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end