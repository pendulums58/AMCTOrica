--스토리텔러-삭월의 빛
function c103550011.initial_effect(c)
	c:SetSPSummonOnce(103550011)
	--링크
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x64a),2,2,c103550011.lcheck)
	c:EnableReviveLimit()
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103550011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cyan.LinkSSCon)
	e1:SetTarget(c103550011.hsptg)
	e1:SetOperation(c103550011.hspop)
	c:RegisterEffect(e1)	
	--파괴 대신
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c103550011.reptg)
	e2:SetValue(c103550011.repval)
	e2:SetOperation(c103550011.repop)
	c:RegisterEffect(e2)
end
function c103550011.lcheck(g,lc)
	return g:IsExists(c103550011.mfilter,1,nil)
end
function c103550011.mfilter(c,e,tp)
	return c:GetOriginalType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c103550011.hspfilter(c,e,tp,zone)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x64a)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),Duel.ReadCard(c,CARDDATA_SETCODE),TYPES_NORMAL_TUNER_MONSTER,500,500,3,RACE_FAIRY,ATTRIBUTE_LIGHT)
end
function c103550011.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and zone~=0 
		and Duel.IsExistingMatchingCard(c103550011.hspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c103550011.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c103550011.hspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	local tc=g:GetFirst()
	Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP,zone)
	tc:AddStoryTellerAttribute(e:GetHandler())
	Duel.SpecialSummonComplete()
end
function c103550011.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x64a)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c103550011.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c103550011.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c103550011.repval(e,c)
	return c103550011.repfilter(c,e:GetHandlerPlayer())
end
function c103550011.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
