--세월을 삼킨 마녀
c111310114.AccessMonsterAttribute=true
function c111310114.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310114.afilter1,aux.TRUE,c111310114.accheck)
	c:EnableReviveLimit()
	--카운터 쌓기
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c111310114.acop)
	c:RegisterEffect(e1)
	--특소
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310114,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c111310114.sptg)
	e2:SetOperation(c111310114.spop)
	c:RegisterEffect(e2)
	--마법 체크
	Duel.AddCustomActivityCounter(111310114,ACTIVITY_CHAIN,c111310114.chainfilter)	
end
function c111310114.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c111310114.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(111310114,tp,ACTIVITY_CHAIN)>0
end
function c111310114.afilter1(c)
	return c:GetSummonLocation()==LOCATION_GRAVE
end
function c111310114.accheck(c,tc,ac)
	local tp=ac:GetControler()
	return Duel.GetCustomActivityCount(111310114,tp,ACTIVITY_CHAIN)>0
end
function c111310114.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c111310114.filter(c,cc,e,tp)
	return (c:IsRace(ad:GetRace()) or c:IsAttribute(ad:GetAttribute())) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetLevel()>0 and cc:IsCanRemoveCounter(tp,0x1,c:GetLevel(),REASON_COST)
end
function c111310114.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ad=e:GetHandler():GetAdmin()
	if chk==0 then return ad and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c111310114.filter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler(),e,tp,ad) end
	local g=Duel.SelectTarget(tp,c111310114.filter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler(),e,tp,ad)
	if g:GetCount()>0 then 
		tc=g:GetFirst() 
		e:GetHandler():RemoveCounter(tp,0x1,tc:GetLevel(),REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function c111310114.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
