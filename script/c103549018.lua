--마칭 파이어 야곱
function c103549018.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),5,2,c103549018.ovfilter,aux.Stringid(103549018,0),2,c103549018.xyzop)
	c:EnableReviveLimit()
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c103549018.cttg)
	e1:SetOperation(c103549018.ctop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103549018,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,103549818)
	e2:SetCost(c103549018.cost)
	e2:SetTarget(c103549018.tg)
	e2:SetOperation(c103549018.op)
	c:RegisterEffect(e2)
	if not c103549018.global_check then
		c103549018.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c103549018.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
c103549018.counter_add_list={0x1325}
function c103549018.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xac6) and c:IsType(TYPE_EFFECT)
end
function c103549018.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,103549018)>0 and Duel.GetFlagEffect(tp,103549918)==0 end
	e:GetHandler():RegisterFlagEffect(tp,103549918,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	return true
end
function c103549018.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and bit.band(r,REASON_EFFECT)~=0 and re then
		Duel.RegisterFlagEffect(tp,103549018,RESET_PHASE+PHASE_END,0,1)
	end
end
function c103549018.filter(c,e,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSummonPlayer(1-tp)
		and (not e or c:IsRelateToEffect(e))
end
function c103549018.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c103549018.filter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,0)
end
function c103549018.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsControler(1-tp) then
			tc:AddCounter(0x1325,1)
		end
		tc=eg:GetNext()
	end
end
function c103549018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1325,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1325,2,REASON_COST)
end
function c103549018.desfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFaceup()
end
function c103549018.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c103549018.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c103549018.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c103549018.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		if chk==0 then return true end
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(800)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
