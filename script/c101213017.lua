--결연
function c101213017.initial_effect(c)
	--엑트 특소 무효/제외
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,101213017)
	e1:SetCondition(c101213017.condition)
	e1:SetTarget(c101213017.target)
	e1:SetOperation(c101213017.operation)
	c:RegisterEffect(e1)
	--효과 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,101213017)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c101213017.condition2)
	e2:SetTarget(c101213017.target2)
	e2:SetOperation(c101213017.operation2)
	c:RegisterEffect(e2)
end
function c101213017.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c101213017.cfilter2(c)
	return c:IsSetCard(0xef3) and c:GetMutualLinkedGroupCount()>0
end
function c101213017.condition(e,tp,eg,ep,ev,re,r,rp)
	local ml=Duel.GetMatchingGroup(c101213017.cfilter2,tp,LOCATION_MZONE,0,nil)
	local g=ml:GetCount()
	return tp~=ep and eg:IsExists(c101213017.cfilter,1,nil,1-tp) and Duel.GetCurrentChain()==0 and g>2
end
function c101213017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c101213017.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function c101213017.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ml=Duel.GetMatchingGroup(c101213017.cfilter2,tp,LOCATION_MZONE,0,nil)
	local g=ml:GetCount()
	return g>2 and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c101213017.cfilter3(c)
	return c:IsSetCard(0xef3) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c101213017.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101213017.cfilter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101213017.cfilter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101213017.cfilter3,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101213017.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c101213017.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101213017.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
