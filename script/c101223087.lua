--백익의 장벽
function c101223087.initial_effect(c)
	--데미지 줄이기
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101223087.cost)
	e1:SetOperation(c101223087.op)
	c:RegisterEffect(e1)
	--공포) 저스트서치의 극한이 있다?
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	cyan.JustSearch(e2,LOCATION_GRAVE,Card.IsType,TYPE_SYNCHRO)
	c:RegisterEffect(e2)
end
function c101223087.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223087.filter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101223087.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local g1=Duel.GetMatchingGroup(c101223087.filter1,tp,LOCATION_EXTRA,0,nil,tc:GetCode())
		Duel.Remove(g1,POS_FACEUP,REASON_COST)
		local ct=g1:GetSum(Card.GetLevel,nil)
		e:SetLabel(ct)
	end
end
function c101223087.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=e:GetLabel()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetLabel(val)
	e4:SetValue(c101223087.damval)
	Duel.RegisterEffect(e4,tp)

end
function c101223087.filter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost() and c:GetLevel()>0
end
function c101223087.filter1(c,code)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost() and c:IsCode(code)
end
function c101223087.damval(e,re,val,r,rp,rc)
	local ct=e:GetLabel()
	if ct==0 then return val end
	local val=val-(ct*100)
	if val<0 then val=0 end
	return val
end