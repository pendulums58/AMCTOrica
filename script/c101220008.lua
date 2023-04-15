--꿈에 빠지다
function c101220008.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101220008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c101220008.ctcost)
	e1:SetTarget(c101220008.target)
	e1:SetOperation(c101220008.activate)
	c:RegisterEffect(e1)	
end
function c101220008.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101220008.rfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c101220008.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c101220008.rfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xefa)
end
function c101220008.filter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c101220008.filter2(c,e,tp,mc)
	return c:IsRank(4) and c:IsSetCard(0xefa) and mc:IsCanBeXyzMaterial(c,tp) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c101220008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c101220008.filter(chkc)
		and Duel.IsExistingMatchingCard(c101220008.filter2,tp,0,LOCATION_MZONE,1,nil,e,tp,chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101220008.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101220008.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101220008.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(tp) or tc:IsImmuneToEffect(e) then return end
	Duel.GetControl(tc,tp,PHASE_END,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101220008.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end