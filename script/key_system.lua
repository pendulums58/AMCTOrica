--키 카드 관련 시스템
TYPE_KEY=0x80000000
EVENT_KEY_UNLOCKED=103555015
KEYTYPE_CONDITION=0x1
KEYTYPE_PROGRESS=0x2
--해방되지 않은 키 속성 부여
function cyan.AddLockedKeyAttribute(c,req)
	--일반 소환 / 특수 소환 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(aux.TRUE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetCondition(aux.TRUE)
	c:RegisterEffect(e3)	
end

function Effect.SetUnlock(e,code)
	e:SetTarget(cyan.UnlockTarget(code))
	e:SetOperation(cyan.UnlockOperation(code))
	e:SetValue(code)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
end

local cics=Card.IsCanBeSpecialSummoned
function Card.IsCanBeSpecialSummoned(c,e,ty,p,tf,...)
	if c:IsType(TYPE_KEY) and not c:IsType(TYPE_TOKEN) then return false end
	return cics(c,e,ty,p,tf,...)
end
function cyan.UnlockTarget(code)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	end
end
function cyan.UnlockOperation(code)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		local token=Duel.CreateToken(tp,code)
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
			cyan.AddUnlockedKeyEffect(tp,token)
			Duel.RaiseSingleEvent(token,EVENT_KEY_UNLOCKED,e,0,tp,tp,0)
			Duel.RaiseEvent(token,EVENT_KEY_UNLOCKED,e,0,tp,tp,0)
			Duel.Delete(e,e:GetHandler())
		end
	end	
end
function cyan.SetUnlockedEffect(c,func)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_KEY_UNLOCKED)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetOperation(func)
	c:RegisterEffect(e1)
end
function cyan.AddUnlockedKeyEffect(p,c)
	
end