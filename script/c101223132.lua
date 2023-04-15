--구천의 전생소녀
function c101223132.initial_effect(c)
	c:SetSPSummonOnce(101223132)
	--엑시즈 소환
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--전생의 유언 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.XyzSSCon)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsCode,101223020)
	c:RegisterEffect(e1)
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCost(c101223132.cost)
	e2:SetTarget(c101223132.thtg)
	e2:SetOperation(c101223132.thop)
	c:RegisterEffect(e2)
end
function c101223132.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg and eg:IsExists(c101223132.chk,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101223132.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101223132.chk,nil,tp)
	local tc=g:Select(tp,1,1,nil)
	if tc:GetCount()>0 then
		local g1=Duel.SelectMatchingCard(tp,c101223132.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetFirst():GetCode())
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(g1,1-tp)
		end
	end
end
function c101223132.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101223132.chk(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and Duel.IsExistingMatchingCard(c101223132.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode()) and c:IsPreviousControler(tp)
end
function c101223132.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end