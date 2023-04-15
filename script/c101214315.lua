--스카이워커 유니버스
function c101214315.initial_effect(c)
	--LRM 한정
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101214315.splimit)
	c:RegisterEffect(e1)
	--레벨마다 효과 적용
	--12 이상 : 레벨이 없는 몬스터 효과 내성
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101214315.lvcon(12))
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c101214315.efilter)	
	c:RegisterEffect(e2)
	--16 이상 : 공격력 감소
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101214315.lvcon(16))
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c101214315.atkval)
	c:RegisterEffect(e3)	
	--25 이상 : 효과 대상 내성
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCondition(c101214315.lvcon(25))
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--40 이상 : 전투 / 효과 내성
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetCondition(c101214315.lvcon(40))
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)	
	--70 이상 : 엑트 특소 봉쇄
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCondition(c101214315.lvcon(70))
	e7:SetTargetRange(0,1)
	e7:SetTarget(c101214315.splimit1)
	c:RegisterEffect(e7)	
	--100 이상 : 각각 1번씩 무효
	local e8a=Effect.CreateEffect(c)
	e8a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8a:SetCode(EVENT_CHAIN_SOLVING)
	e8a:SetRange(LOCATION_MZONE)
	e8a:SetCountLimit(1)
	e8a:SetCondition(c101214315.negcon(LOCATION_HAND))
	e8a:SetOperation(c101214315.negop)
	c:RegisterEffect(e8a)	
	local e8b=e8a:Clone()
	e8b:SetCondition(c101214315.negcon(LOCATION_ONFIELD))	
	c:RegisterEffect(e8b)
	local e8c=e8a:Clone()
	e8c:SetCondition(c101214315.negcon(LOCATION_GRAVE))	
	c:RegisterEffect(e8c)
	local e8d=e8a:Clone()
	e8d:SetCondition(c101214315.negcon(LOCATION_REMOVED))	
	c:RegisterEffect(e8d)
end
function c101214315.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x655)
end
function c101214315.lvcon(lv)
	return function(e,c)
		return e:GetHandler():IsLevelAbove(lv)
	end
end
function c101214315.efilter(e,te)
	return te:GetHandler():IsLevel(0)
end
function c101214315.atkval(e,c)
	return e:GetHandler():GetLevel()*-100
end
function c101214315.splimit1(e,c,tp,sumtp,sumpos)
	return c:IsLocation(LOCATION_EXTRA)
end
function c101214315.negcon(loc)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsLevelAbove(100)	and rp==1-tp and re:GetActivateLocation()==loc
	end
end
function c101214315.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101214315)
	Duel.NegateEffect(ev)
end
