--스타더스트 위치
function c103557002.initial_effect(c)
	--엑시즈 소재 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--레벨 변경
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103557001,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c103557002.lvtg)
	e2:SetOperation(c103557002.lvop)
	c:RegisterEffect(e2)
	--소생
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,103557002)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c103557002.sptg)
	e3:SetOperation(c103557002.spop)	
	c:RegisterEffect(e3)
	--발동 무효 방지
	-- local e5=Effect.CreateEffect(c)
	-- e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e5:SetCode(EFFECT_NEGACT_REPLACE)
	-- e5:SetRange(LOCATION_GRAVE)
	-- e5:SetTarget(c103557002.reptg)
	-- e5:SetValue(c103557002.repval)
	-- e5:SetOperation(c103557002.repop)
	-- c:RegisterEffect(e5)	
end
function c103557002.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLevelAbove(1) and not c:IsLevel(7) end
end
function c103557002.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(7)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c103557002.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and (c:IsSetCard(0xa3) or aux.IsMaterialListType(c,TYPE_SYNCHRO))
end
function c103557002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c103557002.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c103557002.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c103557002.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c103557002.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c103557002.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa3) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_SYNCHRO)
		and c:IsControler(tp)
end
function c103557002.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c103557002.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(103557002,2))
end
function c103557002.repval(e,c)
	return c103557002.repfilter(c,e:GetHandlerPlayer())
end
function c103557002.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
