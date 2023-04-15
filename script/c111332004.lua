--미스트레이더 마린레이어
function c111332004.initial_effect(c)
--엑시즈
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x643),4,2)
	c:EnableReviveLimit()	
--소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c111332004.hspcon)
	e1:SetOperation(c111332004.hspop)
	c:RegisterEffect(e1)
--공수 반전
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c111332004.adtarget)
	e2:SetCode(EFFECT_SWAP_AD)
	c:RegisterEffect(e2)
--마함 서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111332004,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,111332004)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c111332004.cost)
	e3:SetTarget(c111332004.target)
	e3:SetOperation(c111332004.operation)
	c:RegisterEffect(e3)
end
--소환
function c111332004.hspfilter(c,tp,sc)
	return c:IsCode(111332100)
		and c:IsControler(tp) and c:IsReleasable()
end
function c111332004.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c111332004.hspfilter,2,nil,c:GetControler(),c)
end
function c111332004.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c111332004.hspfilter,2,2,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
--공수 반전
--IsOriginalSetCard(코이시프로야 사랑해)
function c111332004.adtarget(e,c)
	return c:IsSetCard(0x643) and not c:IsOriginalSetCard(0x643)
end
--마함 서치
function c111332004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c111332004.filter(c)
	return c:IsSetCard(0x643) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c111332004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111332004.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111332004.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111332004.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end