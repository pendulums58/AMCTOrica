--BST 럭키 배큠
function c101261006.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.FilterBoolFunction(Card.IsCode,BLANK_NAME),1,99)
	c:EnableReviveLimit()	
	--광역 이름 변경
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101261006,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101261006.condition)
	e1:SetOperation(c101261006.operation)
	c:RegisterEffect(e1)
	--공뻥
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c101261006.val)
	c:RegisterEffect(e2)
	--파괴
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101261006,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c101261006.tdcon)
	e3:SetTarget(c101261006.destg)
	e3:SetOperation(c101261006.desop)
	c:RegisterEffect(e3)
end
function c101261006.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c101261006.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(101261000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c101261006.val(e,c)
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c101261006.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*200
end
function c101261006.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c101261006.filter(c)
	return c:IsCode(BLANK_NAME) and c:IsFaceup()
end
function c101261006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c101261006.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return ct>0 end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101261006.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c101261006.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end