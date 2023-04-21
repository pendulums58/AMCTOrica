--미래동결의 수확자
local s,id=GetID()
function s.initial_effect(c)
	--링크 소환
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2,4,s.lcheck)	
	--링크 앞 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_FORCE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetValue(function(e)return ~e:GetHandler():GetLinkedZone() end)
	c:RegisterEffect(e1)
	--링크 앞 봉인
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTarget(s.tg)	
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e3:SetValue(1)	
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_IMMUNE_EFFECT)	
	e4:SetValue(s.efilter)	
	c:RegisterEffect(e4)
	--위치 이동
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.descon)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)	
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsType,1,nil,TYPE_LINK,lc,sumtype,tp)
end
function s.disable(e,c)
	local cc=e:GetHandler()
	return cc:GetLinkedGroup():IsContains(c)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local loct=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loct==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=c:GetLinkedZone(1-tp)&0x1f
	if chk==0 then return re:GetHandler():IsLocation(LOCATION_MZONE) 
		and s.chk(re:GetHandler(),zone) end
	re:GetHandler():CreateEffectRelation(e)
end
function s.chk(c,zone)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,c:GetControler(),LOCATION_REASON_CONTROL,zone)>0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(1-tp)&0x1f
	local tc=re:GetHandler()
	if not tc:IsRelateToEffect(e) or tc:IsControler(tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE,tc:GetControler(),LOCATION_REASON_CONTROL,zone)<=0 then return end
	local i=0
	if not c:IsControler(tp) then i=16 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local nseq=math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~(zone<<i)),2)-i
	Duel.MoveSequence(tc,nseq)	
end
