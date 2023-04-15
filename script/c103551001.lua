--영환성장 큐물루스
function c103551001.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,103551001)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(c103551001.spcost)
	e1:SetTarget(c103551001.sptg)
	e1:SetOperation(c103551001.spop)
	c:RegisterEffect(e1)
	--장착 조건 무시
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_EQUIP_IGNORE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetValue(0xff)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e2)	
	--장착시킨다
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(aux.bfgcost)
	e3:SetCountLimit(1,103551901)
	e3:SetTarget(c103551001.eqtg)
	e3:SetOperation(c103551001.eqop)
	c:RegisterEffect(e3)
end
function c103551001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103551001.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c103551001.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c103551001.tgfilter(c)
	return c:IsAbleToGraveAsCost() and ((c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)) or c:GetEquipTarget())
end
function c103551001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c103551001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c103551001.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x64b) and c:IsType(TYPE_PAIRING)
		and Duel.IsExistingMatchingCard(c103551001.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c,tp)
end
function c103551001.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c103551001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c103551001.filter(chkc,tp) end
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingTarget(c103551001.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c103551001.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c103551001.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c103551001.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end
