--격동하는 초침관찰자
local s,id=GetID()
function s.initial_effect(c)
	--엑시즈 소환
	Xyz.AddProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--무효화 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetValue(s.effectfilter)
	c:RegisterEffect(e1)
	--효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cyan.ovcost(1))
	e2:SetCondition(s.effcon)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end
function s.effectfilter(e,ct)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local count=0
	if s.tychk(tp,TYPE_QUICKPLAY) then count=count+1 end
	if s.tychk(tp,TYPE_CONTINUOUS) then count=count+1 end
	if s.tychk(tp,TYPE_EQUIP) then count=count+1 end
	if s.tychk(tp,TYPE_RITUAL) then count=count+1 end
	if s.tychk(tp,TYPE_FIELD) then count=count+1 end
	if s.tychk(tp,TYPE_GIFT) then count=count+1 end
	if Duel.IsExistingMatchingCard(s.tychk2,tp,LOCATION_GRAVE,0,1,nil) then count=count+1 end
	return count>2
end
function s.tychk(tp,ty)
	return Duel.IsExistingMatchingCard(s.tychk1,tp,LOCATION_GRAVE,0,1,nil,ty)
end
function s.tychk1(c,ty)
	return c:IsType(TYPE_SPELL) and c:IsType(ty)
end
function s.tychk2(c)
	return c:GetType()==TYPE_SPELL
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=re:GetActivateLocation()
	return rp==1-tp and (loc==LOCATION_GRAVE or loc==LOCATION_HAND) and re:IsActiveType(TYPE_MONSTER)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re==1-tp then
		local g=eg:Filter(Card.IsSummonLocation,nil,LOCATION_HAND+LOCATION_GRAVE)
		if #g then
			local tc=g:GetFirst()
			while tc do
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end				
				tc=g:GetNext()
			end
		end
	end
end