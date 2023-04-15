--익스플로잇 드래곤
c111310022.AccessMonsterAttribute=true
function c111310022.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310022.afil1,c111310022.afil2)
	c:EnableReviveLimit()
	--하이잭
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_HIIJACK_ACCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c111310022.hijack)
	c:RegisterEffect(e1)
	--공뻥
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c111310022.condition)
	e2:SetValue(c111310022.atkval)
	c:RegisterEffect(e2)
	--파괴
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c111310022.spcon)
	e3:SetTarget(c111310022.adtg)
	e3:SetOperation(c111310022.adop)
	c:RegisterEffect(e3)
end
function c111310022.afil1(c)
	return c:IsRace(RACE_DRAGON)
end
function c111310022.afil2(c)
	return c:IsDisabled()
end
function c111310022.filter(c)
	return not c:IsType(TYPE_ACCESS)
end
function c111310022.hijack(e,acc,hj)
	return acc:GetLevel()>=8 and not acc:IsSetCard(0x605) and hj:IsLevelBelow(3)
end
function c111310022.atkval(e,c)
	local ad=e:GetHandler():GetAdmin()
	if ad then return (ad:GetAttack())/2 end
	return 0
end
function c111310022.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSequence()<5 and c:IsFaceup()
end
function c111310022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==2 and not eg:IsExists(c111310022.filter,1,nil) and eg:IsContains(e:GetHandler())
end
function c111310022.cfilter(c)
	return c:IsType(TYPE_ACCESS) and c:IsFaceup()
end
function c111310022.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310022.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c111310022.adop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c111310022.cfilter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
end
