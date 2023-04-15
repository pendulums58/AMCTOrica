--후부키류 - 칼날 끊기
function c111333008.initial_effect(c)
--내성
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111333008)	
	e1:SetCondition(c111333008.condition)	
	e1:SetOperation(c111333008.activate)
	c:RegisterEffect(e1)
--샐비지
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111333006,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,111333508)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c111333008.thcon)
	e2:SetTarget(c111333008.thtg)
	e2:SetOperation(c111333008.thop)
	c:RegisterEffect(e2)	
end
function c111333008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>2
end
function c111333008.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)	
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x649))	
	e1:SetValue(c111333008.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)		
	Duel.RegisterEffect(e1,tp)	
end
function c111333008.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
--샐비지
function c111333008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 and aux.exccon(e) 
end
function c111333008.thfilter(c)
	return c:IsCode(111333000) and c:IsAbleToHand()
end
function c111333008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111333008.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c111333008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c111333008.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end