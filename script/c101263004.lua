--환계 - 용문
function c101263004.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--덱특소
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101263004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101263004.spcost)
	e2:SetTarget(c101263004.sptg)
	e2:SetOperation(c101263004.spop)
	c:RegisterEffect(e2)
	--대체 릴리스
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DRACO_ADD)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(4)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
end
function c101263004.rfilter(c,e,tp,ft)
	local lv=c:GetOriginalLevel()
	return lv>0 and c:IsRace(RACE_WYRM) and c:IsReleasable()
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c101263004.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c101263004.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv-1) and c:IsSetCard(0x62f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101263004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c101263004.rfilter,1,nil,e,tp,ft) end
	local g=Duel.SelectReleaseGroup(tp,c101263004.rfilter,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetOriginalLevel())
	Duel.Release(g,REASON_COST)
end
function c101263004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end	
function c101263004.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101263004.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end