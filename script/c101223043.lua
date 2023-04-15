--비익연리의 결말
function c101223043.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101223043.tg)
	e1:SetOperation(c101223043.op)
	c:RegisterEffect(e1)
	--묘지 제외
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c101223043.reptg)
	e2:SetValue(c101223043.repval)
	e2:SetOperation(c101223043.repop)
	c:RegisterEffect(e2)	
end
function c101223043.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101223043.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g1=Duel.SelectTarget(tp,c101223043.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)	
	local tc=g1:GetFirst()
	local g2=Duel.SelectTarget(tp,c101223043.tgfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc)
	g1:Merge(g2)
end
function c101223043.tgfilter(c,tp)
	return Duel.IsExistingTarget(c101223043.tgfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function c101223043.tgfilter2(c,tc)
	local g=c:GetPair()
	return g:IsContains(tc)
end
function c101223043.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not g:GetCount()==2 then return end
	local otsu=g:GetFirst()
	local ningyo=g:GetNext()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(c101223043.efilter1(g))
	otsu:RegisterEffect(e1)
	local e11=Effect.CreateEffect(e:GetHandler())
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e11:SetValue(c101223043.efilter1(g))
	ningyo:RegisterEffect(e11)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(ningyo:GetAttack())
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	otsu:RegisterEffect(e2)	
	local e22=Effect.CreateEffect(e:GetHandler())
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetCode(EFFECT_UPDATE_ATTACK)
	e22:SetValue(otsu:GetAttack())
	e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e22:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	ningyo:RegisterEffect(e22)	
end
function c101223043.efilter1(g)
	return function(e,te)
		return not (g:IsContains(te:GetHandler()) or e~=te)
	end
end
function c101223043.repfilter(c,tp)
	return c:IsFaceup() and c:GetPairCount()>0 and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c101223043.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c101223043.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101223043.repval(e,c)
	return c101223043.repfilter(c,e:GetHandlerPlayer())
end
function c101223043.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
