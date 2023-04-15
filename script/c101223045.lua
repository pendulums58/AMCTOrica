--겸허한 분노
function c101223045.initial_effect(c)
	--패발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c101223045.handcon)
	c:RegisterEffect(e0)
	--발동
	local e1=Effect.CreateEffect(c)	
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c101223045.con)
	e1:SetTarget(c101223045.tg)
	e1:SetOperation(c101223045.op)
	c:RegisterEffect(e1)
end
function c101223045.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c101223045.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c101223045.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c101223045.con(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c101223045.filter,1,nil,tp)
end
function c101223045.filter(c,tp)
	return c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c101223045.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetChainLimit(c101223045.limit(g:GetFirst()))
end
function c101223045.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c or (e:GetHandler()==c and e:IsActiveType(EFFECT_TYPE_ACTIVATE))
			end
end