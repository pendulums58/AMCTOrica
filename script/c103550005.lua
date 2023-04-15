--스토리텔러-피어나는 전개
function c103550005.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--대상 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c103550005.tg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--무효 불가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c103550005.effectfilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c103550005.effectfilter)
	c:RegisterEffect(e4)
	--부여 효과
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(103550005,1))
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,103550005)
	e5:SetCost(c103550005.scost)
	e5:SetCondition(c103550005.scon)
	e5:SetTarget(c103550005.stg)
	e5:SetOperation(c103550005.sop)
	c:RegisterEffect(e5)	
end
function c103550005.tg(e,c)
	return c:IsSetCard(0x64a) and c:IsFaceup()
end
function c103550005.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x103) and bit.band(loc,LOCATION_ONFIELD)~=0
		and te:GetHandler():IsType(TYPE_MONSTER)
end
function c103550005.costfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x64a)
end
function c103550005.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c103550005.costfilter,1,e:GetHandler(),tp) end
	local g=Duel.SelectReleaseGroup(tp,c103550005.costfilter,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function c103550005.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c103550005.sfilter,tp,LOCATION_DECK,0,1,nil) end
	
end
function c103550005.sfilter(c)
	return c:IsSetCard(0x64a) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c103550005.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c103550005.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c103550005.scon(e)
	return e:GetHandler():IsSetCard(0x64a)
end
