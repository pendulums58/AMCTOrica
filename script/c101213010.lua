--냉혹의 결연희
function c101213010.initial_effect(c)
	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2,2)
	c:EnableReviveLimit()
	
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101213010,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,101213910)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101213010.adtg)
	e1:SetOperation(c101213010.operation)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	c:RegisterEffect(e1)
	
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(101213010,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,101213010)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101213010.adtg2)
	e2:SetOperation(c101213010.adop)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	c:RegisterEffect(e2)
end
function c101213010.filter(c,tp,g)
	return c:IsCode(101213012) and g:IsContains(c)
end
function c101213010.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetMutualLinkedGroup()
	if chkc then return c101213010.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101213010.filter,tp,LOCATION_MZONE,0,1,nil,tp,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101213010.filter,tp,LOCATION_MZONE,0,1,1,nil,tp,lg)
end
function c101213010.operation(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=Duel.GetFirstTarget()
	local ct=c:GetMutualLinkedGroupCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	e1:SetValue(ct)
	c:RegisterEffect(e1)
end
function c101213010.filter2(c,tp)
	return c:IsSetCard(0xef3)
end
function c101213010.adtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return c101213010.filter2(chkc,e,tp,ic2) end
	if chk==0 then return Duel.IsExistingTarget(c101213010.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101213010.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101213010.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end