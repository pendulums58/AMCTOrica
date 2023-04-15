--흑백의 수호자 커버스
function c101225007.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()	
	--세트
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101225007,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,101225007)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101225007.cost)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101225007.settg)
	e1:SetOperation(c101225007.setop)
	c:RegisterEffect(e1)
end
--세트
function c101225007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101225007.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c101225007.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		end
end
function c101225007.setfilter(c,mc,tp)
	return c:IsCode(31677606) and c:IsSSetable()
end
function c101225007.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101225007.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local sc=g:GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
	end
end
