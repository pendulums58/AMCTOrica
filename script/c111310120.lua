--풀아머드 모듈러
function c111310120.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101223120.afilter1,aux.TRUE)
	c:EnableReviveLimit()	
	--장착
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.AccSSCon)
	e1:SetTarget(c101223120.eqtg)
	e1:SetOperation(c101223120.eqop)
	c:RegisterEffect(e1)
	--어드민에 장착 + 특소
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101223120.sptg)
	e2:SetOperation(c101223120.spop)
	c:RegisterEffect(e2)
end
function c101223120.afilter1(c)
	return c:GetEquipCount()>0
end
function c101223120.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223120.ufilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperation(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c101223120.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101223120.ufilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local ct=0
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c101223120.eqfilter,tp,LOCATION_MZONE,0,1,nil,tc) then
				ct=Duel.SelectOption(tp,aux.Stringid(101223120,0),aux.Stringid(101223120,1))
			else
				ct=0
			end
		else
			ct=1
		end
		if ct==0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			local g1=Duel.SelectMatchingCard(tp,c101223120.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tc)
			if g1:GetCount()>0 then
				local tc1=g1:GetFirst()
				Duel.Equip(tp,tc,tc1)
			end
		end
	end
end
function c101223120.ufilter(c,e,tp)
	return c:IsType(TYPE_UNION) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c101223120.eqfilter,tp,LOCATION_MZONE,0,1,nil,c)))
end
function c101223120.eqfilter(c,eq)
	return c:IsFaceup() and c:IsType(TYPE_UNION) and aux.CheckUnionEquip(c,eq) and c:CheckUnionTarget(eq)
end
function c101223120.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ad=e:GetHandler():GetAdmin()
	if chkc then return ad~=nil and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101223120.esfilter(chkc,ad) end
	if chk==0 then return ad and ad:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(LOCATION_SZONE)>0 and Duel.IsExistingTarget(c101223120.esfilter,tp,LOCATION_GRAVE,0,1,nil,ad) end
	local tc=Duel.SelectTarget(tp,c101223120.esfilter,tp,LOCATION_GRAVE,0,1,1,nil,ad)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,ad,1,tp,LOCATION_OVERLAY)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,tp,LOCATION_GRAVE)
end
function c101223120.esfilter(c,ad)
	return aux.CheckUnionEquip(ad,c) and c:IsType(TYPE_UNION)
end
function c101223120.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():GetAdmin()~=nil and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local ad=e:GetHandler():GetAdmin()
		if Duel.SpecialSummon(ad,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Equip(tp,ad,tc)
		end
	end
end