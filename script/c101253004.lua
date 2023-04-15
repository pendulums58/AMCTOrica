--액세스 코드『여환무장』
function c101253004.initial_effect(c)
	--패에서 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,101253004)
	e1:SetCondition(c101253004.hspcon)
	e1:SetOperation(c101253004.hspop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--자신에게 장착
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101253004,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101253004.condition)
	e2:SetTarget(c101253004.target)
	e2:SetOperation(c101253004.operation)
	c:RegisterEffect(e2)	
	--레벨 상승
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c101253004.value)
	c:RegisterEffect(e3)
end
function c101253004.hspfilter(c,ft,tp)
	return c:IsSetCard(0x611) and c:IsAbleToGrave() and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) and c:IsFaceup()
end
function c101253004.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c101253004.hspfilter,tp,LOCATION_ONFIELD,0,1,nil,ft,tp)
end
function c101253004.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c101253004.hspfilter,tp,LOCATION_ONFIELD,0,1,1,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101253004.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c101253004.eqfilter(c)
   return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x611)
end
function c101253004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101253004.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c101253004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eq=Duel.SelectMatchingCard(tp,c101253004.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local eqc=eq:GetFirst()
	if eqc and Duel.Equip(tp,eqc,c) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c101253004.eqlimit)
		e1:SetLabelObject(c)
		eqc:RegisterEffect(e1)
	end
end
function c101253004.eqlimit(e,c)
   return c==e:GetLabelObject()
end
function c101253004.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x611)
end
function c101253004.value(e,c)
	local tp=e:GetHandler():GetControler()
	local ct=Duel.GetMatchingGroupCount(c101253004.filter2,tp,LOCATION_SZONE,0,nil)
	return ct*2
end