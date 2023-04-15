--어드민즈 오퍼레이션
function c111310119.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,111310119)
	e1:SetCondition(c111310119.condition)
	e1:SetTarget(c111310119.target)
	e1:SetOperation(c111310119.activate)
	c:RegisterEffect(e1)	
end
function c111310119.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_ACCESS)
end
function c111310119.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c111310119.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c111310119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_ONFIELD)
end
function c111310119.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
		and Duel.GetAdminCount(tp,1,nil)>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(111310119,0)) then
		if Duel.RemoveAdmin(tp,1,0,1,1,REASON_EFFECT)~=0 then
			local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
			if g1:GetCount()>0 then Duel.Destroy(g1,REASON_EFFECT) end
		end
	end
end