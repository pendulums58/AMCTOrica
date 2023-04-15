--익스플로잇 M(모듈) 드래곤
function c101223118.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223120.pfilter,c101223120.mfilter,2,2)
	c:EnableReviveLimit()
	--공격력 상승
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101223118.val)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cyan.PairSSCon)
	e2:SetTarget(c101223118.destg)
	e2:SetOperation(c101223118.desop)
	c:RegisterEffect(e2)
end
function c101223120.pfilter(c)
	return c:IsRace(RACE_DRAGON)
end
function c101223120.mfilter(c,pair)
	return c:IsAttribute(pair:GetAttribute()) and c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c101223118.val(e,c)
	if not e:GetHandler():GetSequence()<5 then return 0 end
	return e:GetHandler():GetPairCount()*200
end
function c101223118.chk(c)
	return c:GetPair():IsExists(Card.IsType,1,nil,TYPE_PAIRING)
end
function c101223118.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c101223118.chk,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,tp,LOCATION_ONFIELD)
end
function c101223118.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c101223118.chk,tp,LOCATION_MZONE,0,nil)
	if ct>0 then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end