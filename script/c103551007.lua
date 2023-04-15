--여환성장 무라쿠모노카미
function c103551007.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,aux.TRUE,c103551007.mfilter,2,2)
	c:EnableReviveLimit()
	--모두 참조
	local e1=Effect.CreateEffect(c)
	e1:SetCode(103551007)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetValue(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e1)	
	--장착 조건 무시
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_EQUIP_IGNORE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetValue(1)
	e2:SetRange(0xff)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e2)
	--공격력 증가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c103551007.tgfilter)
	e3:SetValue(c103551007.atkval)
	c:RegisterEffect(e3)
	--파괴
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(103551007,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCost(c103551007.descost)
	e4:SetTarget(c103551007.destg)
	e4:SetOperation(c103551007.desop)
	c:RegisterEffect(e4)	
end
function c103551007.mfilter(c,pair)
	return c:IsSetCard(0x64b) and c:GetLevel()>pair:GetLevel() and pair:GetLevel()>0
end
function c103551007.atkval(e,c)
	return e:GetHandler():GetEquipCount()*200
end
function c103551007.tgfilter(e,c)
	local tc=e:GetHandler()
	return c==tc or (tc:GetPair():GetCount()>0 and tc:GetPair():IsContains(c))
end
function c103551007.costfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsAbleToRemoveAsCost()
end
function c103551007.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=e:GetHandler():GetEquipGroup()
	g=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c103551007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c103551007.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
