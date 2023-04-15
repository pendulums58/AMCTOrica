--플라워힐의 화이트블룸
function c103554026.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c103554026.unlockeff)	
	--회복
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(103554026,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c103554026.tg)
	e1:SetOperation(c103554026.op)
	c:RegisterEffect(e1)
	--플라워힐 특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetDescription(aux.Stringid(103554026,1))
	e2:SetCountLimit(1)
	e2:SetCost(c103554026.spcost)
	e2:SetTarget(c103554026.sptg)
	e2:SetOperation(c103554026.spop)
	c:RegisterEffect(e2)
end
function c103554026.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetTargetRange(LOCATION_FZONE+LOCATION_HAND,0)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTarget(aux.FilterBoolFunction(Card.IsType,TYPE_FIELD))
	e1:SetValue(c103554026.efilter)	
	Duel.RegisterEffect(e1,tp)
end
function c103554026.efilter(e,re)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwner()~=e:GetOwner()
end
function c103554026.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103554026.pfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c103554026.pfilter,tp,LOCATION_HAND,0,1,99,nil)
	e:SetLabelObject(g)
	Duel.ConfirmCards(g,1-tp)
	g:KeepAlive()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,g:GetCount()*800,tp,0)
end
function c103554026.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject():Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Recover(tp,g:GetCount()*800,REASON_EFFECT)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(8)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+EVENTS_STANDARD)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end	
function c103554026.pfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:GetLevel()~=8 and not c:IsPublic()
end
function c103554026.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103554026.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c103554026.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c103554026.cfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToGraveAsCost()
end
function c103554026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c103554026.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c103554026.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsSetCard(0x657) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c103554026.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c103554026.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end