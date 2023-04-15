--만발 벚꽃
function c103555009.initial_effect(c)
	--엑시즈 소환
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x65a),3,2)
	c:EnableReviveLimit()	
	--1턴에 1번만 엑시즈 가능
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c103555009.regcon)
	e1:SetOperation(c103555009.regop)
	c:RegisterEffect(e1)	
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c103555009.descost)
	e2:SetTarget(c103555009.destg)
	e2:SetOperation(c103555009.desop)
	c:RegisterEffect(e2)
	--공업
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c103555009.atktg)
	e3:SetValue(c103555009.atkval)
	c:RegisterEffect(e3)
	cyan.AddSakuraEffect(c)
end
function c103555009.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c103555009.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c103555009.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c103555009.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(103555009) and bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c103555009.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)	
end
function c103555009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c103555009.chk,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,tp,LOCATION_ONFIELD)
end
function c103555009.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c103555009.chk,tp,LOCATION_MZONE,0,nil)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c103555009.chk(c)
	return c:IsFaceup() and c:IsSetCard(0x65a)
end
function c103555009.atktg(e,c)
	return c:IsSetCard(0x65a)
end
function c103555009.atkval(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetMatchingGroupCount(c103555009.atkfilter,tp,LOCATION_MZONE,0,nil)*200
end
function c103555009.atkfilter(c)
	return c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN) and c:IsSetCard(0x65a)
end