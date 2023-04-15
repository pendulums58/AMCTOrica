--밤의 그늘 플라네타리움
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--체인 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,id)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.thcon)
	cyan.JustSearch(e3,LOCATION_DECK,Card.IsRace,RACE_SPELLCASTER,Card.IsAttribute,ATTRIBUTE_DARK)
	c:RegisterEffect(e3)
	--대상 변경
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.tarcon)
	e4:SetTarget(s.tartg)
	e4:SetOperation(s.tarop)
	c:RegisterEffect(e4)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRace(RACE_SPELLCASTER) and rc:IsAttribute(ATTRIBUTE_DARK) and re:IsActiveType(TYPE_MONSTER) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActiveType()==TYPE_SPELL and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function s.tarcon(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return #g==1 and g:GetFirst()==e:GetHandler() and ep==1-tp
end
function s.tarfilter(c,ev)
	return Duel.CheckChainTarget(ev,c) and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.tartg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return c~=chkc and chkc:IsLocation(LOCATION_ONFIELD) and s.tarfilter(chkc,ev) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tarfilter,tp,LOCATION_ONFIELD,0,1,c,ev) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.tarfilter,tp,LOCATION_ONFIELD,0,1,1,c,ev)
end
function s.tarop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end