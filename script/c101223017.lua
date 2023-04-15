--투페어 딜러
function c101223017.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223017.pfilter,c101223017.mfilter,1,1)
	c:EnableReviveLimit()
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101223017,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c101223017.drcon)
	e1:SetTarget(c101223017.drtg)
	e1:SetOperation(c101223017.drop)
	c:RegisterEffect(e1)
	--공격 선언시
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101223017,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(c101223017.target)
	e2:SetOperation(c101223017.operation)
	c:RegisterEffect(e2)	
end
function c101223017.pfilter(c)
	return c:GetPairCount()>0
end
function c101223017.mfilter(c,pair)
	local lv=pair:GetLevel()
	return lv>0 and c:GetLevel()==lv*2
end	
function c101223017.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223017.drfilter,1,nil)
end
function c101223017.drfilter(c)
	return c:IsReason(REASON_PAIR)
end
function c101223017.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101223017.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101223017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101223017.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	if tc:IsType(TYPE_MONSTER) and tc:IsType(TYPE_SPELL)
		and Duel.IsExistingMatchingCard(c101223017.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101223017,0)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c101223017.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(g,1-tp)
		end
		Duel.ShuffleHand(1-tp)
	end
end
function c101223017.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL)
end