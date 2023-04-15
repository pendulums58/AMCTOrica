--흘러내리는 색채의 행진
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
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
	return c:IsType(TYPE_ACCESS) and c:IsAbleToRemoveAsCost()
end
function s.check(g,req)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1 and g:GetSum(Card.GetAttack)>req
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	if e:GetLabel()==1 then
		Duel.SetChainLimit(cyan.oppofalse)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0xe000e0)
	local seq=math.log(bit.rshift(dis,16),2)
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(s.distg)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetLabel(seq)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetOperation(s.disop)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetLabel(seq)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e6:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e6:SetTarget(s.distg)
	e6:SetReset(RESET_PHASE+PHASE_END)
	e6:SetLabel(seq)
	Duel.RegisterEffect(e6,tp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>1 
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis)
		local seq1=math.log(bit.rshift(dis1,16),2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(s.distg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(seq1)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetOperation(s.disop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabel(seq1)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e3:SetTarget(s.distg)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetLabel(seq1)
		Duel.RegisterEffect(e3,tp)		
	end
end
function s.handcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
end
function s.distg(e,c)
	local seq=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return aux.GetColumn(c,tp)==seq
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetLabel()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if seq<=4
		and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then
		Duel.NegateEffect(ev)
	end
end