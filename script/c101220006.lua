--RUM(랭크 업 매직)-나이트메어 콜
function c101220006.initial_effect(c)
	--랭크 업
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101220006.target)
	e1:SetOperation(c101220006.activate)
	c:RegisterEffect(e1)	
end
function c101220006.filter1(c,e,tp)
	return (c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsControler(tp)
		and Duel.IsExistingMatchingCard(c101220006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)) or
		(c:IsFaceup() and c:IsDisabled() and c:IsControler(1-tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsControlerCanBeChanged() and c:GetLevel()>0
		and Duel.IsExistingMatchingCard(c101220006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetLevel()+1))
end
function c101220006.filter2(c,e,tp,mc,rk)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return (mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and (c:IsRank(rk) or c:IsRank(rk+1)) and c:IsSetCard(0xefa) 
	and mc:IsCanBeXyzMaterial(c,tp) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)) or
	(Duel.IsExistingMatchingCard(c101220006.spfilter,tp,LOCATION_MZONE,0,1,nil) and c:IsCode(101220018)
		and mc:IsCanBeXyzMaterial(c,tp) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false))
end
function c101220006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101220006.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101220006.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101220006.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101220006.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if tc:IsControler(1-tp) and not tc:IsDisabled() and Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101220006.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
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
function c101220006.spfilter(c)
	return c:IsSetCard(0xefa) and c:GetRank()==5
end