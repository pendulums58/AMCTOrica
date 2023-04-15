--질주의 결연희
function c101213022.initial_effect(c)
	--패특소
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101213022)
	e1:SetCondition(c101213022.spcon)
	e1:SetTarget(c101213022.sptg)
	e1:SetOperation(c101213022.spop)
	c:RegisterEffect(e1)
	--효과 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c101213022.efcon)
	e2:SetOperation(c101213022.efop)
	c:RegisterEffect(e2)
end
function c101213022.spfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetSummonPlayer()==tp and c:IsSetCard(0xef3)
end
function c101213022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101213022.spfilter,1,nil,tp)
end
function c101213022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101213022.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0xef3)
end
function c101213022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
			local g=Duel.SelectMatchingCard(tp,c101213022.filter,tp,LOCATION_MZONE,0,1,1,nil)
			if g:GetCount()>0 then
				local gc=g:GetFirst()
				Duel.SwapSequence(c,gc)
			end
		end
	end
end
function c101213022.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetReasonCard():IsSetCard(0xef3)
end
function c101213022.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end