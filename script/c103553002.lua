--앵화난무
function c103553002.initial_effect(c)
	aux.AddCodeList(c,103553000)
	--이나리소녀 강화
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
	e1:SetRange(LOCATION_SZONE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c103553002.tg)
	e1:SetValue(3000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c103553002.efilter)
	c:RegisterEffect(e3)
	--앵화난무 발사
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e4:SetCode(103553002)
	e4:SetRange(LOCATION_SZONE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetTarget(c103553002.furiosotg)
	e4:SetOperation(c103553002.furiosoop)
	c:RegisterEffect(e4)
	--스택 초기화
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(c103553002.lfop)
	c:RegisterEffect(e5)
end
function c103553002.tg(e,c)
	return c:IsCode(103553000)
end
function c103553002.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c103553002.furiosotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,g:GetCount()*400,1-tp,0)
end
function c103553002.furiosoop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local g1=Duel.GetOperatedGroup()
		Duel.Damage(1-tp,g1:GetCount()*400,REASON_EFFECT)
	end
	if Duel.GetTurnPlayer()==1-tp then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetTargetRange(LOCATION_ONFIELD,0)
		e3:SetTarget(aux.TRUE)
		e3:SetValue(aux.indoval)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c103553002.lfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetPlayerCounter(tp,0x2,3)
end