--오아시스 도미네이터
function c111310138.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310138.afil1,aux.TRUE)
	c:EnableReviveLimit()	
	--소환 턴 패 / 묘지 발동 제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c111310138.sdop)
	c:RegisterEffect(e1)
	--무효화
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46935289,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c111310138.discon)
	e2:SetCost(cyan.dhcost(1))
	e2:SetTarget(c111310138.distg)
	e2:SetOperation(c111310138.disop)
	c:RegisterEffect(e2)
end
function c111310138.afil1(c)
	return c:GetSummonLocation()==LOCATION_DECK
end
function c111310138.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c111310138.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c111310138.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_HAND
end
function c111310138.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c111310138.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c111310138.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		local ad=e:GetHandler():GetAdmin()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and ad and Duel.IsExistingMatchingCard(c111310137.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,ad)
			and Duel.SelectYesNo(tp,aux.Stringid(111310138,0)) then
			local g=Duel.SelectMatchingCard(tp,c111310137.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,ad)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
 
	end
end
function c111310137.spfilter(c,e,tp,ad)
	return c:IsRace(ad:GetRace()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsAttribute(ad:GetAttribute())
end