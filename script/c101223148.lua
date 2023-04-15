--깨져버린 영혼의 행진
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
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
	return c:IsType(TYPE_LINK) and c:IsAbleToRemoveAsCost()
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
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTarget(aux.TRUE)
	e1:SetTargetRange(0,0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,2,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function s.handcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
end

