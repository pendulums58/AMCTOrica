--회유하는 신비
local s,id=GetID()
function s.initial_effect(c)
	--신비 공통 효과
	cyan.AddHaloEffect(c,TYPE_EFFECT)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,id)
	e1:SetValue(s.hspval)
	c:RegisterEffect(e1)
	--소재 시 서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.acccon)
	e2:SetCountLimit(1,{id,1})
	cyan.JustSearch(e2,LOCATION_DECK,Card.IsSetCard,SETCARD_MYSTERY,Card.IsType,TYPE_MONSTER)
	c:RegisterEffect(e2)	
end
function s.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=(zone|tc:GetColumnZone(LOCATION_MZONE,0,0,tp))
	end
	return 0,zone
end
function s.acccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_ACCESS
end