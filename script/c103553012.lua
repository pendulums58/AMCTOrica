--방랑병장 순간개방
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
	return #g>=7 and (cyan.IsUnlockState(e,tp) or g:GetClassCount(Card.GetCode)==#g)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=3
	if cyan.IsUnlockState(e,tp) then ct=7 end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct
		and Duel.CheckGiftEffect(tp,s.gfilter) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.chk(c,tp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=3
	if cyan.IsUnlockState(e,tp) then ct=7 end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,ct)
	local g=Duel.GetDecktopGroup(p,ct)	
	g=g:Filter(s.chk,nil,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.BreakEffect()
		Duel.ShuffleDeck(p)
	end	
	if cyan.IsUnlockState(e,tp) then
		if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			and Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==1 then
			local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
		else
			cyan.AddFuriosoStack(tp,3)
		end
	end
	Duel.AddGiftEffect(e,s.gfilter,s.geffect,2400,3000)
end
function s.spfilter(c,e,tp)
	return c:IsCode(103553000) and c:IsAbleToHand()
end
function s.gfilter(c)
	return true
end
function s.geffect(e,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetDescription(aux.Stringid(id,1))	
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,rc:GetCode())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
		if cyan.IsUnlockState(e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,tp,false,false) then
			Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.thfilter(c,tc)
	return c:IsAbleToHand() and c:IsCode(tc:GetCode())
end