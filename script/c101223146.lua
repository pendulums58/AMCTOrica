--모여드는 초목의 행진
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--상대 턴에도 패에서 발동 가능
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.FALSE)		
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	local atk=10000
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_GRAVE,0,nil)
	local g1=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_EXTRA,0,nil):GetMaxGroup(Card.GetAttack):GetFirst()
	if g and g1 then g:Merge(g1) 
		atk=atk-g:GetSum(Card.GetAttack)
	end
	if chk==0 then return lp>=atk end
	local cg=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	local tg=cg:SelectSubGroup(tp,s.check,false,0,99,10000-lp)
	atk=10000
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
		atk=atk-tg:GetSum(Card.GetAttack)
	end
	Duel.PayLPCost(tp,atk)
	if tg:GetCount()>2 or atk>=4000 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function s.costfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function s.check(g,req)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1 and g:GetSum(Card.GetAttack)>req
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()==1 then
		Duel.SetChainLimit(cyan.oppofalse)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(s.drcon1)
	e1:SetOperation(s.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(s.drcon2)
	e3:SetOperation(s.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.handcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
end
function s.cfilter(c,tp)
	return c:IsControler(1-tp) and not c:IsReason(REASON_DRAW) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function s.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function s.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,id)==0
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.drop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,id)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,1,REASON_EFFECT)
end
