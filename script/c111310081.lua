--클라이언트 브로커
function c111310081.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--자신의 효과
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(111310081)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c111310081.condition)
	c:RegisterEffect(e1)
end
function c111310081.condition(e)
   return e:GetHandler():GetFlagEffect(111310081)==0 and e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end