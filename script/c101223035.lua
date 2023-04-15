--고아수호자, 카히라
function c101223035.initial_effect(c)
	--단짝 세팅
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_DECK)
	e0:SetTarget(c101223035.comptg)
	e0:SetOperation(c101223035.compop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1)	
	--버프
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TRUE)
	e2:SetValue(300)
	c:RegisterEffect(e2)	
	--직접 공격
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TRUE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
end
function c101223035.comptg(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,COMPANION_COMPLETE)
		and not Duel.IsExistingMatchingCard(c101223035.cpfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
		and Duel.GetTurnCount()==1 end
end
function c101223035.cpfilter(c)
	return not c:IsRace(RACE_BEAST+RACE_WINGBEAST+RACE_INSECT+RACE_DINOSAUR+RACE_FISH)
end

function c101223035.compop(e,tp,ep,eg,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,COMPANION_COMPLETE) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(101223035,0)) then
		cyan.companiontheffect(c)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(COMPANION_COMPLETE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
	end
end