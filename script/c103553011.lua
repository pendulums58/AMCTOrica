--앵화전술「격류」
function c103553011.initial_effect(c)
	aux.AddCodeList(c,103553000)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,103553011)
	e1:SetTarget(c103553011.thtg)
	e1:SetOperation(c103553011.thop)
	c:RegisterEffect(e1)
	--장착
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	-- e2:SetType(EFFECT_TYPE_QUICK_O)
	-- e2:SetCode(EVENT_BE_BATTLE_TARGET)
	-- e2:SetRange(LOCATION_GRAVE)
	-- e2:SetCondition(c103553011.atkcon)
	-- e2:SetTarget(c103553011.target)
	-- e2:SetOperation(c103553011.operation)
	-- c:RegisterEffect(e2)
	-- local e3=Effect.CreateEffect(c)
	-- e3:SetDescription(aux.Stringid(103553011,1))
	-- e3:SetCategory(CATEGORY_EQUIP)
	-- e3:SetType(EFFECT_TYPE_QUICK_O)
	-- e3:SetCode(EVENT_CHAINING)
	-- e3:SetRange(LOCATION_GRAVE)
	-- e3:SetCondition(c103553011.tgcon)
	-- e3:SetTarget(c103553011.target)
	-- e3:SetOperation(c103553011.operation)
	-- c:RegisterEffect(e3)
end
function c103553011.thfilter(c)
	return aux.IsCodeListed(c,103553000) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c103553011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c103553011.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c103553011.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c103553011.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,sg1)
		local cg=sg1:RandomSelect(1-tp,1)
		local tc=cg:GetFirst()
		tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if cyan.IsUnlockState(e,tp,eg,ep,ev,re,r,rp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c103553011.spfilter,tp,0x13,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(103553011,0)) then
			local g1=Duel.SelectMatchingCard(tp,c103553011.spfilter,tp,0x13,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
				Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
function c103553011.spfilter(c,e,tp)
	return c:IsCode(103553000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c103553011.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and at:IsFaceup() and at:IsCode(103553011)
end
function c103553011.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(103553011) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c103553011.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c103553011.cfilter,1,nil,tp)
end
function c103553011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if ev then local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end