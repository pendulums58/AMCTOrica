--프라임 패스『액세스』
function c101223153.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101223153.afil,c101223153.afil)
	c:EnableReviveLimit()
	--액세스 소환으로만 소환 가능
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.acclimit)
	c:RegisterEffect(e1)	
	--소환 턴 서치 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cyan.AccSSCon)
	e2:SetOperation(c101223153.sdop)
	c:RegisterEffect(e2)
	--LP 회복
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101223153.reccon)
	e4:SetOperation(c101223153.recop)
	c:RegisterEffect(e4)
	--유언으로 필드 클린
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetOperation(c101223153.regop)
	c:RegisterEffect(e5)
end
function c101223153.afil(c)
	return c:IsType(TYPE_ACCESS)
end
function c101223153.sdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK+LOCATION_GRAVE))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(0,1)
	Duel.RegisterEffect(e2,tp)
end
function c101223153.reccon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and rp==1-tp and e:GetHandler():GetFlagEffect(1)>0
end
function c101223153.recop(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	if ad==nil then return end
	local lv=ad:GetLevel()
	if lv>0 then
		Duel.Recover(tp,lv*200,REASON_EFFECT)
	end
end
function c101223153.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_BATTLE+REASON_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(101223153,1))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetTarget(c101223153.destg)
		e1:SetOperation(c101223153.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetRange(LOCATION_REMOVED)
		c:RegisterEffect(e2)
	end
end
function c101223153.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101223153.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
