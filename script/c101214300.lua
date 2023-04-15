--스카이워커 베이퍼
function c101214300.initial_effect(c)
	--기동 덱특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101214300)
	e1:SetTarget(c101214300.sptg)
	e1:SetOperation(c101214300.spop)
	c:RegisterEffect(e1)
	--레벨 상승
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c101214300.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101214300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetLevel()-c:GetOriginalLevel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c101214300.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101214300.spfilter(c,e,tp,lv)
	return lv>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xef5) and c:IsLevelBelow(lv)
		and c:IsType(TYPE_TUNER)
end
function c101214300.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local ct=c:GetLevel()-c:GetOriginalLevel()
	if ct>0 and c:IsRelateToEffect(e) then
		local atk=c:GetOriginalLevel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)		
		Duel.BreakEffect()
		lv=lv-c:GetLevel()
		if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local g=Duel.SelectMatchingCard(tp,c101214300.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ct)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c101214300.op(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return end
	local g=eg:Filter(c101214300.filter,nil,tp)
	local ct=g:GetCount()
	local c=e:GetHandler()
	if ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)	
	end

end
function c101214300.filter(c,tp)
	return c:IsSetCard(0xef5) and c:IsControler(tp)
end