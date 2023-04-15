--마칭 파이어 암드 프로퍼시
function c103549009.initial_effect(c)
	--code
	aux.EnableChangeCode(c,82705573,LOCATION_SZONE+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103549009,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,103549009)
	e2:SetCondition(c103549009.condition)
	e2:SetTarget(c103549009.target)
	e2:SetOperation(c103549009.activate)
	c:RegisterEffect(e2)
	--disable zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103549009,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c103549009.zcon)
	e3:SetCost(c103549009.zcost)
	e3:SetTarget(c103549009.ztg)
	e3:SetOperation(c103549009.zop)
	c:RegisterEffect(e3)
end
c103549009.counter_add_list={0x1325}
function c103549009.filter(c,tp)
	return c:IsSetCard(0xac6) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c103549009.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c103549009.filter,1,nil,tp)
end
function c103549009.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c103549009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103549009.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c103549009.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c103549009.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		e:GetHandler():AddCounter(0x1325,2)
	end
end
function c103549009.zfilter(c)
	return (c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and c:IsPreviousControler(tp)
end
function c103549009.zcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c103549009.zfilter,1,nil,tp)
end
function c103549009.zcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1325,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1325,2,REASON_COST)
end
function c103549009.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,0xe000e0)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function c103549009.zop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e:GetHandler():RegisterEffect(e1)
end
