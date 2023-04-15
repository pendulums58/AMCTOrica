--엄숙한 커뮤니케이터
function c101223040.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223040.pfilter,c101223040.mfilter,2,2)
	c:EnableReviveLimit()
	--상대 필드도 페어로
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_PAIR)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c101223040.matval)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101223040.descon)
	e2:SetTarget(c101223040.destg)
	e2:SetOperation(c101223040.desop)
	c:RegisterEffect(e2)	
	--필드 제외
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c101223040.rmtg)
	e3:SetOperation(c101223040.rmop)
	c:RegisterEffect(e3)
end
function c101223040.pfilter(c)
	return c:IsLevelAbove(5)
end
function c101223040.mfilter(c,pair)
	return c:GetLevel()<pair:GetLevel()
end
function c101223040.matval(e,pc,mc,tp)
	if e:GetOwner()~=pc then return false end
	return mc:GetControler()==e:GetHandler():GetOwner()
end
function c101223040.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c101223040.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then eg:IsExists(c101223040.desfilter,1,nil,tp) end
	local g=eg:Filter(c101223040.desfilter,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)	
end
function c101223040.desfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp)
end
function c101223040.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101223040.desfilter,nil)
	g:AddCard(e:GetHandler())	
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if not g:IsContains(e:GetHandler()) then return end
	Duel.Destroy(g,REASON_EFFECT)
end
function c101223040.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c101223040.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		end
		e1:SetCountLimit(1)
		e1:SetOperation(c101223040.spop2)
		c:RegisterEffect(e1)	
	end
end
function c101223040.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetOwner()
	if c:IsCanBeSpecialSummoned(e,0,p,false,false) and Duel.GetLocationCount(p,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,p,p,false,false,POS_FACEUP)
	end
end