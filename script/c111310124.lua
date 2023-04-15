--라이프베슬 프라임
function c111310124.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310124.afil1,c111310124.afil2)
	c:EnableReviveLimit()
	--제외
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cyan.AccSSCon)
	e1:SetTarget(c111310124.rmtg)
	e1:SetOperation(c111310124.rmop)
	c:RegisterEffect(e1)
	--묘지 특소 제약
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c111310124.sumlimit)
	c:RegisterEffect(e2)
	--파괴 대체
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c111310124.reptg)
	c:RegisterEffect(e3)
end
function c111310124.afil1(c)
	return c:IsRace(RACE_FIEND)
end
function c111310124.afil2(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c111310124.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c111310124.desfilter(chkc) 
		and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c111310124.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tc=Duel.SelectTarget(tp,c111310124.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tp,LOCATION_MZONE)	
end
function c111310124.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c111310124.desfilter(c)
	return not c:IsRace(RACE_DRAGON+RACE_FIELD+RACE_FAIRY+RACE_CREATORGOD)
end
function c111310124.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c111310124.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and ad~=nil end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.SendtoGrave(ad,REASON_EFFECT)
		return true
	else return false end
end
