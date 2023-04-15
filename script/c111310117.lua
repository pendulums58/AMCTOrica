--창천의 집배원
function c111310117.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,c111310117.afilter1)
	c:EnableReviveLimit()	
	--1드로
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310117,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.AccSSCon)
	e1:SetTarget(c111310117.drtarg)
	e1:SetOperation(c111310117.drop)
	c:RegisterEffect(e1)	
	--무효화 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c111310117.effectfilter)
	c:RegisterEffect(e2)
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cyan.dhcost(1))
	e3:SetTarget(c111310117.thtg)
	e3:SetOperation(c111310117.thop)
	c:RegisterEffect(e3)
end
function c111310117.afilter1(c)
	return c:GetSummonLocation()==LOCATION_DECK
end
function c111310117.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c111310117.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c111310117.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local eg,ep,ev=Duel.GetChainEvent(ct)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	if te:IsHasCategory(CATEGORY_DRAW) then return true end
	if te:IsHasCategory(CATEGORY_SEARCH) then return true end
	return (ex1 and ((dv1&LOCATION_GRAVE==LOCATION_GRAVE or dv1&LOCATION_DECK==LOCATION_DECK) or g1 and g1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_GRAVE)))
end
function c111310117.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAdmin()~=nil and Duel.IsExistingMatchingCard(c111310117.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAdmin()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111310117.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ad=c:GetAdmin()
	if ad then
		local tc=Duel.SelectMatchingCard(tp,c111310117.thfilter,tp,LOCATION_DECK,0,1,1,nil,ad)
		if tc:GetCount()>0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c111310117.thfilter(c,ad)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and (c:IsRace(ad:GetRace()) or c:IsAttribute(ad:GetAttribute()))
end
