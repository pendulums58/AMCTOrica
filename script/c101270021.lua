--별자리에 새긴 여정
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--제외
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(s.rmcost)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ssfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,s.ssfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SSet(tp,g)~=0 then
			local g1=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_HAND,0,1,1,nil)
			if g1:GetCount()>0 and Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)~=0 then
				local tc=g1:GetFirst()
				if tc:IsLevel(1) and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
					local g2=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
					if g2:GetCount()>0 then
						Duel.SendtoGrave(g2,REASON_EFFECT)
					end
				end
			end
		end
	end
end
function s.dfilter(c)
	return c:IsSetCard(SETCARD_CR) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function s.ssfilter(c)
	return c:IsSetCard(SETCARD_CR) and c:IsSpell() and c:IsSSetable()
end
function s.tgfilter(c)
	return c:IsSetCard(SETCARD_CR) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(s.adfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	local g=Duel.SelectMatchingCard(tp,s.adfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst():GetAdmin()
	Duel.SendtoGrave(tc,REASON_COST)
end
function s.adfilter(c)
	local ad=c:GetAdmin()
	return c:IsSetCard(SETCARD_CR) and ad and ad:IsAbleToGraveAsCost()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end