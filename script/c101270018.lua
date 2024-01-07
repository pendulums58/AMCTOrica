--스타더스트 프레이어
local s,id=GetID()
function s.initial_effect(c)
	--해금
	cyan.AddLockedKeyAttribute(c)
	--해금
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.ulcon)
	e1:SetUnlock(id+1)
	c:RegisterEffect(e1)		
end
function s.ulcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.chk,1,nil) and ep==tp
end
function s.chk(c)
	return c:IsSetCard(SET_STARDUST) and c:IsLevel(10) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)

end