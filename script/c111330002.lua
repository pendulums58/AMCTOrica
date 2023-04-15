--방랑의 잔불여우
function c111330002.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,111330002)
	e1:SetCost(c111330002.spcost)
	e1:SetTarget(c111330002.sptg)
	e1:SetOperation(c111330002.spop)
	c:RegisterEffect(e1)
	--토큰 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,111330102)
	e2:SetCost(cyan.selfrelcost)
	e2:SetTarget(c111330002.tktg)
	e2:SetOperation(c111330002.tkop)
	c:RegisterEffect(e2)	
end
function c111330002.cfilter(c,ft,tp)
	return c:IsCode(TOKEN_EMBERFOX) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function c111330002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c111330002.cfilter,1,nil,ft,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c111330002.cfilter,1,1,nil,ft,tp)
	Duel.Release(sg,REASON_COST)
end
function c111330002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c111330002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.IsExistingMatchingCard(c111330002.thfilter,tp,LOCATION_GRAVE,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(111330002,0)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c111330002.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(g,1-tp)
			end
		end
	end
end
function c111330002.thfilter(c)
	return c:IsSetCard(0x638) and c:IsAbleToHand()
end
function c111330002.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Cyan.EmberTokenCheck(tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c111330002.tkop(e,tp,eg,ep,ev,re,r,rp)
	if c111330002.tktg(e,tp,eg,ep,ev,re,r,rp,0) then
		local c=e:GetHandler()
		local token=Cyan.CreateEmberToken(tp)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Cyan.AddEmberTokenAttribute(token)
	end
	Duel.SpecialSummonComplete()
end