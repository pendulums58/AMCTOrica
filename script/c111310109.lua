--못미더운 관찰자
c111310109.AccessMonsterAttribute=true
c111310109.AmassEffect=1
function c111310109.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310109.afil1,aux.TRUE)
	c:EnableReviveLimit()	
	--축적
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c111310109.amcon)
	e1:SetTarget(c111310109.amtg)
	e1:SetOperation(c111310109.amop)	
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c111310109.amcon1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c111310109.amtg)
	e2:SetOperation(c111310109.amop)		
	c:RegisterEffect(e2)
	--파괴안됨
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c111310109.reptg)
	c:RegisterEffect(e4)
end
function c111310109.afil1(c)
	return c:GetAttack()~=c:GetBaseAttack()
end
function c111310109.amcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310109.amcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c111310109.filter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c111310109.filter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c111310109.amtg(e,tp,ep,eg,ev,re,r,rp,chk)
	local ad=e:GetHandler():GetAdmin()
	if chk==0 then return ad and ad:IsAttackAbove(1) and Duel.AmassCheck(tp) end
end
function c111310109.amop(e,tp,ep,eg,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	if ad==nil then return end
	Duel.Amass(e,ad:GetAttack())
end
function c111310109.repfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c111310109.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c111310109.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c111310109.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
