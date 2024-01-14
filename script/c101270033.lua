--디스어드밴티지 엔젤
local s,id=GetID()
function s.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,aux.TRUE,s.mfilter,1,1)
	c:EnableReviveLimit()		
	--공격력 상승(영구)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--소환 성공시
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cyan.PairSSCon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.mfilter(c,pair)
	return c:GetAttack()>pair:GetAttack()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.chk,1,nil,tp) and r==REASON_EFFECT and rp==1-tp
end
function s.chk(c)
	return c:GetPreviousControler()==tp
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(400)
	c:RegisterEffect(e1)	
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,g:GetSum(Card.GetAttack),tp,nil)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		local g1=Duel.GetOperatedGroup()
		Duel.Damage(1-tp,g1:GetSum(Card.GetAttack),REASON_EFFECT)
	end	
end
function s.desfilter(c,tc)
	local atk=tc:GetAttack()
	return c:GetAttack()<atk
end