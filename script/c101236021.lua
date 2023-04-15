--혼합음료 문블라스트
function c101236021.initial_effect(c)
	--소재 불가 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYHCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_ACCESS_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_PAIRING_MATERIAL)
	c:RegisterEffect(e6)
	--1번 효과
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(101236021,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BLEND)
	e7:SetTarget(c101236021.blendtg)
	e7:SetOperation(c101236021.blendop)
	c:RegisterEffect(e7)
	--2번 효과
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(101236021,1))
	e8:SetCountLimit(1)
	e8:SetCategory(CATEGORY_CHEMICAL)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c101236021.cmtg)
	e8:SetOperation(c101236021.cmop)
	c:RegisterEffect(e8)
end
function c101236021.filter(c,e,tp)
	return c:IsCode(101236003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101236021.blendtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101236021.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101236021.blendop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101236021.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101236021.cmfilter(c)
	return c:IsFaceup() and c:IsCode(101236009)
end
function c101236021.cmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101236021.cmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101236021.cmfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101236021.cmfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101236021.cmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	if Duel.Destroy(c,REASON_EFFECT)>0 then
		yipi.SelectChemical(tp,tc)
		if Duel.SelectYesNo(tp,aux.Stringid(101236021,2)) then
			yipi.Blend(tc,tp)
		end
	end
end