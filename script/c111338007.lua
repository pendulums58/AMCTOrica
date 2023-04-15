--R-PINE 코스 체인지
function c111338007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111338007,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c111338007.target)
	e1:SetOperation(c111338007.setop)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111338007,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c111338007.cost)
	e2:SetTarget(c111338007.target2)
	e2:SetOperation(c111338007.setop2)
	c:RegisterEffect(e2)
end
function c111338007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c111338007.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		end
end
function c111338007.setfilter(c,mc,tp)
	return c:IsCode(94634433) and c:IsSSetable()
end
function c111338007.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c111338007.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local sc=g:GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	end
end
--cost
function c111338007.cfilter1(c,tp)
	return c:IsCode(94634433) and c:IsSSetable()
end
function c111338007.cfilter2(c)
	return c:IsSetCard(0x656) and c:IsType(TYPE_SPELL) and not c:IsCode(111338007) and c:IsSSetable()
end
function c111338007.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c111338007.cfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c111338007.cfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
		end
end
function c111338007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x656) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x656)
	Duel.Release(g,REASON_COST)
end
function c111338007.setop2(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.SelectMatchingCard(tp,c111338007.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
	local sc=g2:GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
	end
	local g3=Duel.SelectMatchingCard(tp,c111338007.cfilter2,tp,LOCATION_DECK,0,1,1,nil)
	local sc=g3:GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e3)
	end
end