--신을 삼킨 바르그 펜리르
function c111335005.initial_effect(c)
--싱크로 소환
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x652),aux.NonTuner(nil),1)
	c:EnableReviveLimit()	
--장착 얼티메이텀	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111335005,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,111335005)
	e1:SetCondition(c111335005.eqcon)
	e1:SetTarget(c111335005.eqtg)
	e1:SetOperation(c111335005.eqop)
	c:RegisterEffect(e1)	
--공뻥 얼티메이텀	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c111335005.atkval)
	c:RegisterEffect(e2)
--구속된 만큼 강해진다
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c111335005.val)
	c:RegisterEffect(e3)
end
--장착 얼티메이텀
function c111335005.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c111335005.filter(c,ec)
	return c:IsCode(111335009) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c111335005.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c111335005.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c111335005.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c111335005.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,3,nil,c)
	local tc=g:GetFirst()
	while tc do
	Duel.Equip(tp,tc,c)
	tc=g:GetNext()
	end
end
--공뻥 얼티메이텀
function c111335005.atkval(e,c)
	local rec=c:GetDefense()
	if rec<0 then rec=0 end
	return rec*1
end
--구속된 만큼 강해진다
function c111335005.spfilter(c,tp)
	return c:IsFaceup() and c:IsCode(111335009)
end
function c111335005.val(e,c)
	return c:GetEquipGroup():FilterCount(Card.IsCode,nil,111335009)*1400
end