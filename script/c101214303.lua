--스카이워커 피누스
function c101214303.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101214303)
	e1:SetCondition(c101214303.spcon)
	c:RegisterEffect(e1)
	--덱특소
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101214403)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101214303.sptg)
	e2:SetOperation(c101214303.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101214303.chk(c)
	return c:IsFaceup() and c:IsLevelAbove(c:GetOriginalLevel()+5)
end
function c101214303.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c101214303.chk,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c101214303.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101214303.tgfilter(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c101214303.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local tc=Duel.SelectTarget(tp,c101214303.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c101214303.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local lv=tc:GetOriginalLevel()
		local g=Duel.SelectMatchingCard(tp,c101214303.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101214303.tgfilter(c,e,tp)
	return c:GetLevel()>c:GetOriginalLevel() and Duel.IsExistingMatchingCard(c101214303.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetOriginalLevel())
end
function c101214303.spfilter(c,e,tp,lv)
	return c:IsSetCard(0xef5) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end