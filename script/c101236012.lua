--발할라즈 블랙 옵스
function c101236012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,101236012)
	e1:SetCondition(c101236012.condition)
	e1:SetTarget(c101236012.target)
	e1:SetOperation(c101236012.activate)
	c:RegisterEffect(e1)
end
function c101236012.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c101236012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c101236012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabelObject(eg)
	local tg=e:GetLabelObject()
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c101236012.midfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101236012.midfilter2,tp,LOCATION_GRAVE,0,1,nil) then
		local g=Duel.SelectTarget(tp,c101236012.midfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(c101236012.rivafilter1,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
	if Duel.IsExistingMatchingCard(c101236012.puppyfilter1,tp,LOCATION_MZONE,0,1,nil) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1,101236912)
		e1:SetTarget(c101236012.settg)
		e1:SetOperation(c101236012.setop)
		c:RegisterEffect(e1)
	end
end
function c101236012.midfilter1(c)
	return c:IsFaceup() and c:IsCode(101236003)
end
function c101236012.midfilter2(c)
	return c:IsAbleToHand() and (c:IsSetCard(0x658) or c:IsSetCard(0x659)) and not c:IsCode(101236012)
end
function c101236012.rivafilter1(c)
	return c:IsFaceup() and c:IsCode(101236004)
end
function c101236012.puppyfilter1(c)
	return c:IsFaceup() and c:IsCode(101236005)
end
function c101236012.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c101236012.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end