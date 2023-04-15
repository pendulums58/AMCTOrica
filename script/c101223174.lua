--스타레일 포토그래퍼
function c101223174.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetLocation(LOCATION_HAND)
	e1:SetCondition(c101223174.ulcon)
	e1:SetUnlock(101223175)
	c:RegisterEffect(e1)
	if not c101223174.global_check then
		c101223174.global_check=true	
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_CANNOT_DISEFFECT)
		ge1:SetCondition(c101223174.immcon)
		ge1:SetValue(c101223174.effectfilter)
		Duel.RegisterEffect(ge1,0)
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EVENT_CHAINING)
		ge0:SetCondition(c101223174.p0gcon)
		ge0:SetCountLimit(1)
		ge0:SetLabelObject(ge1)
		ge0:SetOperation(c101223174.p0gop)
		Duel.RegisterEffect(ge0,0)		
	end			
end
function c101223174.ulcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_HAND
		and not re:GetHandler():IsType(TYPE_KEY)
end
function c101223174.chainfilter(re,tp,cid)
	return re:GetHandler():GetControler()==tp
end
function c101223174.effectfilter(e,ct)
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return tp==0 and e:GetLabelObject()==te
end
function c101223174.p0gcon(e)
	return rp==0
end
function c101223174.p0gop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabelObject(re)
end