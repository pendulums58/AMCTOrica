--짙은 미래의 크리에이터
c101270004.AmassEffect=1
function c101270004.initial_effect(c)
	--축적
	local e1=Effect.CreateEffect(c)
	e1:SetRange(LOCATION_HAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cyan.selfdiscost)
	e1:SetCountLimit(1,101270004)
	e1:SetTarget(c101270004.amtg)
	e1:SetOperation(c101270004.amop)
	c:RegisterEffect(e1)
	--묘지회수
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101270004)
	cyan.JustSearch(e2,LOCATION_GRAVE,Card.IsType,TYPE_SPELL+TYPE_TRAP,Card.AmassCard,1)
	c:RegisterEffect(e2)
end
function c101270004.amtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.AmassCheck(tp) end
end
function c101270004.amop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Amass(e,500)
	local val=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN):GetSum(Card.GetAttack,nil)
	local g=Duel.SelectMatchingCard(tp,c101270004.defilter,tp,0,LOCATION_MZONE,1,1,nil,val-1)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c101270004.defilter(c,val)
	return c:IsFaceup() and c:IsAttackBelow(val)
end