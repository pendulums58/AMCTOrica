--중기갑공룡 봉고론고
function c101223120.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223120.pfilter,c101223120.mfilter,2,2)
	c:EnableReviveLimit()	
	--뒷면 수비로 한다
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101223120.postg)
	e1:SetOperation(c101223120.posop)
	c:RegisterEffect(e1)
	--뒷면 제외
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101223120,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c101223120.descon)
	e2:SetTarget(c101223120.destg)
	e2:SetOperation(c101223120.desop)
	c:RegisterEffect(e2)	
end
function c101223120.pfilter(c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c101223120.mfilter(c,pair)
	return not c:IsAttribute(pair:GetAttribute())
end
function c101223120.posfilter(c,def,tp)
	return c:IsCanChangePosition() and c:GetAttack()<def and c:IsControler(1-tp)
end
function c101223120.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101223120.posfilter,1,nil,e:GetHandler():GetDefense(),tp)
		and not eg:IsContains(e:GetHandler()) end
end
function c101223120.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(c101223120.posfilter,nil,c:GetDefense(),tp)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function c101223120.descon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return e:GetHandler()==Duel.GetAttacker() and d and d:IsFacedown() and d:IsDefensePos()
end
function c101223120.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.GetAttackTarget(),1,0,0)
end
function c101223120.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() then
		Duel.Remove(d,POS_FACEUP,REASON_EFFECT)
	end
end
