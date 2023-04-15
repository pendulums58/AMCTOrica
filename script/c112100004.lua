--청파색의 현자 올베르스
function c112100004.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Xyz summon procedure
	Xyz.AddProcedure(c,nil,1,2)
	--세트
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101225007,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,101225007)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c112100004.cost)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c112100004.settg)
	e1:SetOperation(c112100004.setop)
	c:RegisterEffect(e1)
end
function c112100004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c112100004.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c112100004.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		end
end
function c112100004.setfilter(c,mc,tp)
	return c:IsSetCard(0x65b) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function c112100004.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c112100004.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local sc=g:GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
	end
end