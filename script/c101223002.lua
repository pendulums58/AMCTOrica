--재귀 고스트
function c101223002.initial_effect(c)
	--탈취
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101223002,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cyan.selftgcost)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,101223002)
	e1:SetCondition(c101223002.condition)
	e1:SetTarget(c101223002.target)
	e1:SetOperation(c101223002.operation)
	c:RegisterEffect(e1)
	if not c101223002.global_check then
		c101223002.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c101223002.chkcon)
		ge1:SetOperation(c101223002.chkop)
		Duel.RegisterEffect(ge1,0)
	end	
end
function c101223002.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and c:GetFlagEffect(101223002)~=0
end
function c101223002.chkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()>2 and ep==1-tp
end
function c101223002.chkop(e,tp,eg,ep,ev,re,r,rp)
	c:RegisterFlagEffect(101223002,RESET_PHASE+PHASE_END,0,1)
end
function c101223002.tgfilter(c)
	return c:IsControlerCanBeChanged()
end
function c101223002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223002.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function c101223002.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c101223002.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local c=g:GetFirst()
	if c and Duel.GetControl(c,tp)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LOCATION_EXTRA)
		c:RegisterEffect(e3,true)
	end
end
