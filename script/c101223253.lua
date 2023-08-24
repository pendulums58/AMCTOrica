--아너 오브 블랙프레임
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,3,2,nil,nil,99)	
	--특수 소환 조건
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.abcon)
	e0:SetOperation(s.abop)
	c:RegisterEffect(e0)
	--소환시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.XyzSSCon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
end
function s.abcon(e,tp,ep,eg,ev,re,r,rp)
	return Duel.GetTurnCount()==1
end
function s.abop(e,tp,ep,eg,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_EXTRA,0,1,c,TYPE_XYZ) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		e1:SetValue(aux.FALSE)
		c:RegisterEffect(e1)
	end
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetOverlayCount()>0 end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ov=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(ov,REASON_EFFECT)
	local ct=1
	for i=1,ov:GetCount() do
		ct = ct*2
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c:GetAttack()*ct)
		c:RegisterEffect(e1)		
	end
end