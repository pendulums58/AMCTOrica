--밀고의 괴도 베르너
local s,id=GetID()
function s.initial_effect(c)
	cyan.AddLockedKeyAttribute(c)	
	--게임 개시시 내 덱의 카드에 허구의 효과를 부여(창조한 카드 비교)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_DECK)
	e0:SetCondition(s.abcon)
	--e0:SetTarget(s.abtg)
	e0:SetOperation(s.abop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1)
	--개방
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.ulcon)
	e2:SetUnlock(id+1)
	c:RegisterEffect(e2)	
end
function s.abcon(e,tp,ep,eg,ev,re,r,rp)
	return Duel.GetTurnCount()==1
end
function s.abtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,aux.TRUE,tp) end
end
	
function s.abop(e,tp,ep,eg,ev,re,r,rp)
	local c=e:GetHandler()
	local DeckCount = Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,nil)	
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(id)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end

function s.ulcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return not c:IsHasEffect(id) and ep==tp
end