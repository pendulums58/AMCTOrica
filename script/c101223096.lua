--연주하여 밝히는 하늘
function c101223096.initial_effect(c)
	--발동(T 릴리스)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101223096)
	e1:SetCost(c101223096.thcost)
	e1:SetTarget(c101223096.thtg)
	e1:SetOperation(c101223096.thop)
	c:RegisterEffect(e1)
	--발동(P 릴리스)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,101223096)
	e2:SetCost(c101223096.spcost)
	e2:SetTarget(c101223096.sptg)
	e2:SetOperation(c101223096.spop)
	c:RegisterEffect(e2)
end
function c101223096.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.ChechReleaseGroupEx(tp,c101223096.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c101223096.costfilter,1,1,nil)
	if g:GetCount()>0 then
		e:SetLabelObject(g:GetFirst())
		Duel.Release(g,REASON_EFFECT)
	end
end
function c101223096.costfilter(c)
	return c:IsType(TYPE_TUNER) and Duel.IsExistingMatchingCard(c101223096.thfilter,tp,LOCATION_DECK,0,1,nil,c)
		and c:GetLevel()>0
end
function c101223096.thfilter(c,tc)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:GetLeftScale()==tc:GetLevel()
end
function c101223096.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c101223096.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local g=Duel.SelectMatchingCard(tp,c101223096.thfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101223096.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.ChechReleaseGroupEx(tp,c101223096.costfilter1,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c101223096.costfilter1,1,1,nil,e,tp)
	if g:GetCount()>0 then
		e:SetLabelObject(g:GetFirst())
		Duel.Release(g,REASON_EFFECT)
	end
end
function c101223096.costfilter1(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c101223096.spfilter,tp,LOCATION_DECK,0,1,nil,c,e,tp)
		and c:GetLevel()>0
end
function c101223096.spfilter(c,tc,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(tc:GetLevel())
end
function c101223096.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101223096.spop(e,tp,eg,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.SelectMatchingCard(tp,c101223096.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end