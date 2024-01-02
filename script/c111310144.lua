--청룡신 아트라시온
local s,id=GetID()
function s.initial_effect(c)
	--특수 소환 제약
	c:SetSPSummonOnce(id)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()	
	--패로 되돌리기
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.AccSSCon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ad=e:GetHandler():GetAdmin()
	if chk==0 then return ad and (ad:GetRace()>0 or ad:GetAttribute()>0) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ad=e:GetHandler():GetAdmin()
	if ad and (ad:GetRace()>0 or ad:GetAttribute()>0) then
		local op=Duel.SelectOption(tp,1319,1321)
		if op==0 then
			--속성
			local at=ad:GetAttribute()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(1)
			e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,at))
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			Duel.RegisterEffect(e2,tp)			
		else
			local rc=ad:GetRace()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(1)
			e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,rc))
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			Duel.RegisterEffect(e2,tp)	
		end
	end
end