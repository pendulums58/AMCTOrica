--별의 정렬
function c103557007.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,103557007)
	e1:SetCost(c103557007.cost)
	e1:SetTarget(c103557007.target)
	e1:SetOperation(c103557007.activate)
	c:RegisterEffect(e1)	
	--스덕 특소
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c103557007.spcost)
	e2:SetTarget(c103557007.sptg)
	e2:SetOperation(c103557007.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(103557007,ACTIVITY_SPSUMMON,c103557007.counterfilter)
end
function c103557007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(103557007,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c103557007.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c103557007.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_SYNCHRO) and (c:IsSetCard(0xa3) or aux.IsMaterialListType(c,TYPE_SYNCHRO)))
end
function c103557007.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or 
	(c:IsType(TYPE_SYNCHRO) and (c:IsSetCard(0xa3) or aux.IsMaterialListType(c,TYPE_SYNCHRO)))
end
function c103557007.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c103557007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c103557007.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c103557007.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c103557007.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BE_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCondition(c103557007.drcon)
		e2:SetTarget(c103557007.drtg)
		e2:SetOperation(c103557007.drop)
		tc:RegisterEffect(e2)
	end
end
function c103557007.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and re:GetHandler():IsSetCard(0xa3)
end
function c103557007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103557007.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c103557007.thfilter(c)
	return c:IsSetCard(0xa3) and c:IsAbleToHand()
end
function c103557007.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(103557007,0)) then
		local g=Duel.SelectMatchingCard(tp,c103557007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function c103557007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c103557007.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c103557007.costfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		g:AddCard(e:GetHandler())
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c103557007.costfilter(c)
	return c:IsSetCard(0xa3) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c103557007.filter1(c,e,tp)
	return c:IsCode(44508094) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c103557007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c103557007.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c103557007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c103557007.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end